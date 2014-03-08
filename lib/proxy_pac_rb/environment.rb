# encoding: utf-8
module ProxyPacRb
  class Environment

    private

    attr_reader :days, :months, :my_ip_address, :time, :io, :available_methods

    public

    def initialize(options = {})
      @days          = { "MON" => 1, "TUE" => 2, "WED" => 3, "THU" => 4, "FRI" => 5, "SAT" => 6, "SUN" => 7 }
      @months        = { "JAN" => 1, "FEB" => 2, "MAR" => 3, "APR" => 4, "MAY" => 5, "JUN" => 6, "JUL" => 7, "AUG" => 8, "SEP" => 9, "OCT" => 10, "NOV" => 11, "DEC" => 12 }

      @my_ip_address = options.fetch(:my_ip_address, '127.0.0.1')
      @time          = options.fetch(:time, Time.now)
      @io            = options.fetch(:io, $stderr)
      @available_methods = [
        :alert,
        :isPlainHostName,
        :dnsDomainIs,
        :localHostOrDomainIs,
        :isResolvable,
        :isInNet,
        :dnsResolve,
        :MyIpAddress ,
        :dnsDomainLevels,
        :shExpMatch,
        :weekdayRange,
        :dateRange,
        :timeRange,
      ]
    end

    def alert(msg)
      io.puts msg
    end

    def isPlainHostName(host)
      not host.include? "."
    end

    def dnsDomainIs(host, domain)
      host.end_with? domain
    end

    def localHostOrDomainIs(host, hostdom)
      host == hostdom or hostdom.include? host
    end

    def isResolvable(host)
      !!resolve_host(host)
    end

    def isInNet(host, pattern, mask)
      IPAddr.new(pattern).mask(mask).include? resolve_host(host)
    end

    def dnsResolve(host)
      resolve_host(host)
    end

    def MyIpAddress 
      IPAddr.new(my_ip_address).to_s
    end

    def dnsDomainLevels(host)
      host.scan(".").size
    end

    def shExpMatch(str, shexp)
      ::File.fnmatch(shexp, str)
    end

    def weekdayRange(wd1, wd2 = nil, gmt = nil)
      fail Exceptions::InvalidArgument, "wd1 needs to be one of #{days.keys.collect {|k| "\"#{k}\""}.join(', ')}" unless days.key?(wd1)
      fail Exceptions::InvalidArgument, "wd2 needs to be one of #{days.keys.collect {|k| "\"#{k}\""}.join(', ')}" if wd2 and !days.key?(wd2)

      if gmt == "GMT"
        local_time = time.utc 
      else
        local_time = time
      end

      (days[wd1]..days[wd2 || wd1]).include? local_time.wday == 0 ? 7 : local_time.wday
    end

    def dateRange(*args)
      fail Exceptions::InvalidArgument, "range needs to be one of #{months.keys.collect {|k| "\"#{k}\""}.join(', ')}" if args.any? { |a| !months.key?(a)  }

      if args.last == "GMT" and args.pop
        local_time = time.utc 
      else
        local_time = time
      end

      case args.size
      when 1
        check_date_part(local_time, args[0])
      when 2
        check_date_part(local_time, args[0]..args[1])
      when 4
        check_date_part(local_time, args[0]..args[2]) and
          check_date_part(local_time, args[1]..args[3])
      when 6
        check_date_part(local_time, args[0]..args[3]) and
          check_date_part(local_time, args[1]..args[4]) and
          check_date_part(local_time, args[2]..args[5])
      else
        fail ArgumentError, "wrong number of arguments"
      end
    end

    def timeRange(*args)
      fail Exceptions::InvalidArgument, "args need to be integer values" if args.any? { |a| !a.kind_of? Fixnum }

      if args.last == "GMT" and args.pop
        local_time = time.utc 
      else
        local_time = time
      end

      case args.size
      when 1
        local_time.hour == args[0]
      when 2
        (args[0]..args[1]).include? local_time.hour
      when 4
        (args[0]..args[2]).include? local_time.hour and
          (args[1]..args[3]).include? local_time.min
      when 6
        (args[0]..args[3]).include? local_time.hour and
          (args[1]..args[4]).include? local_time.min  and
          (args[2]..args[5]).include? local_time.sec
      else
        fail ArgumentError, "wrong number of arguments"
      end
    end

    private

    def check_date_part(time, part, operation = :==)
      case part
      when String
        time.month.send(operation, months[part])
      when Integer
        if part < 100
          time.day.send(operation, part)
        else
          time.year.send(operation, part)
        end
      when Range
        check_date_part(time, part.begin, :>=) and check_date_part(time, part.end, :<=)
      else
        fail ArgumentError, "wrong type"
      end
    end

    def resolve_host(host)
      Resolv.each_address(host) do |address|
        begin
          return address if IPAddr.new(address).ipv4?
        rescue ArgumentError
        end
      end

      # We couldn't find an IPv4 address for the host
      nil
    rescue Resolv::ResolvError, NoMethodError
      # Have to rescue NoMethodError because jruby has a bug with non existant hostnames
      # See http://jira.codehaus.org/browse/JRUBY-6054
      nil
    end
  end
end
