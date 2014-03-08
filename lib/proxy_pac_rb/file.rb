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

      environment = Environment.new(my_ip_address: client_ip, time: time)

      context = ProxyPacRb::Parser.runtime.compile(source)
      context.include environment

      fail ArgumentError, "url is missing host" unless uri.host
      context.call("FindProxyForURL", url, uri.host)
    end

  end
end
