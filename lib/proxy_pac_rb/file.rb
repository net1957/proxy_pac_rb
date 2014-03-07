require "uri"

module ProxyPacRb
  require "pac/functions"

  class File
    attr_reader :source, :context

    def initialize(source)
      @source = source.dup.freeze
      @context = ProxyPacRb.runtime.compile(@source)
      @context.include Functions
    end

    def find(url)
      uri = URI.parse(url)
      raise ArgumentError, "url is missing host" unless uri.host
      context.call("FindProxyForURL", url, uri.host)
    end
  end
end
