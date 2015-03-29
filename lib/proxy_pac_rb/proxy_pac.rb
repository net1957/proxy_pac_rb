module ProxyPacRb
  # Proxy pac file
  class ProxyPac
    private

    attr_reader :javascript

    public

    attr_reader :file

    def initialize(javascript:, file:)
      @javascript = javascript
      @file       = file
    end

    def find(url)
      uri = Addressable::URI.heuristic_parse(url)
      fail UrlInvalidError, 'url is missing host' unless uri.host

      javascript.FindProxyForURL(url, uri.host)
    end
  end
end
