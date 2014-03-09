module ProxyPacRb
  class File

    private

    attr_reader :javascript

    public

    def initialize(javascript)
      @javascript  = javascript
    end

    def find(url)
      uri = Addressable::URI.heuristic_parse(url)
      fail Exceptions::UrlInvalid, "url is missing host" unless uri.host

      javascript.call("FindProxyForURL", url, uri.host)
    end
  end
end
