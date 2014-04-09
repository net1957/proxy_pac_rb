# encoding: utf-8
module ProxyPacRb
  class Environment

    private

    attr_reader :days, :months, :client_ip, :time, :io, :javascript_function_templates

    public

    attr_reader :available_methods

    def initialize(options = {})
      @days          = { "MON" => 1, "TUE" => 2, "WED" => 3, "THU" => 4, "FRI" => 5, "SAT" => 6, "SUN" => 0 }
      @months        = { "JAN" => 1, "FEB" => 2, "MAR" => 3, "APR" => 4, "MAY" => 5, "JUN" => 6, "JUL" => 7, "AUG" => 8, "SEP" => 9, "OCT" => 10, "NOV" => 11, "DEC" => 12 }

      @client_ip     = options.fetch(:client_ip, '127.0.0.1')
      @time          = options.fetch(:time, Time.now)
      @io            = options.fetch(:io, $stderr)

      @javascript_function_templates = ProxyPacJs

      @available_methods = [
        :alert,
        :isPlainHostName,
        :dnsDomainIs,
        :localHostOrDomainIs,
        :isResolvable,
        :isInNet,
        :dnsResolve,
        :dnsDomainLevels,
        :shExpMatch,
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

    def dnsDomainLevels(host)
      host.scan(".").size
    end

    def shExpMatch(str, shexp)
      ::File.fnmatch(shexp, str)
    end

    private

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

    public

    def prepare(string)
      if client_ip
        string << "\n\n"
        string << javascript_function_templates.my_ip_address_template(client_ip)
      end

      if time
        string << javascript_function_templates.time_variables
        string << "\n\n"
        string << javascript_function_templates.week_day_range_template(time)
        string << "\n\n"
        string << javascript_function_templates.week_day_range_template(time)
        string << "\n\n"
        string << javascript_function_templates.date_range_template(time)
        string << "\n\n"
        string << javascript_function_templates.time_range_template(time)
      end

      string
    end
  end
end
