module ProxyPacRb
  class File

    private

    attr_reader :source, :context

    public

    def initialize(source)
      @source  = source.dup.freeze
    end


    def find(url, options = {})
      uri = Addressable::URI.heuristic_parse(url)

      client_ip = options.fetch(:client_ip, '127.0.0.1')
      time      = options.fetch(:time, Time.now)

      require 'v8'
      require 'therubyracer'

      environment = Environment.new(my_ip_address: client_ip, time: time)
      V8::Context.new(:with => environment) do |cxt|
        puts cxt.eval("FindProxyForURL('#{url}', '#{uri.host}')" + source)
      end

      #context     = ProxyPacRb::Parser.runtime.compile(source, environment)

      #fail ArgumentError, "url is missing host" unless uri.host
      #context.call("FindProxyForURL", url, uri.host)
    end

  end
end
