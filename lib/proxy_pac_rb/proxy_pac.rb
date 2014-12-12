# encoding: utf-8
module ProxyPacRb
  class ProxyPac
    private

    attr_reader :path

    public

    def initialize(path)
      @path = path
    end

    def content
      fail
    end

    private

    def read_proxy_pac(path)
      uri = Addressable::URI.parse(path)

      uri.path = ::File.expand_path(uri.path) if uri.host.nil?

      ENV.delete 'HTTP_PROXY'
      ENV.delete 'HTTPS_PROXY'
      ENV.delete 'http_proxy'
      ENV.delete 'https_proxy'

      open(uri, proxy: false).read
    end
  end
end
