# encoding: utf-8
module ProxyPacRb
  # Dump Proxy pac to file system
  class ProxyPacLoader
    private

    attr_reader :loaders, :default_loader

    public
    def initialize
      @loaders = []
      @loaders << ProxyPacStringLoader.new
      @loaders << ProxyPacFileLoader.new
      @loaders << ProxyPacUriLoader.new

      @default_loader = ->{ ProxyPacStringLoader.new }
    end

    # Load proxy pac
    #
    # @param [#source] proxy_pac
    #   The proxy.pac
    def load(proxy_pac)
      loaders.find(default_loader) { |l| l.suitable_for? proxy_pac }.load(proxy_pac)
    end
  end

  # Load proxy pac from string
  class ProxyPacStringLoader
    def load(proxy_pac)
      proxy_pac.content = proxy_pac.source.to_s
      proxy_pac.type = :string

      self
    end

    def suitable_for?(proxy_pac)
      proxy_pac.source.include? 'FindProxyForURL'
    end
  end

  # Load proxy pac from file
  class ProxyPacFileLoader
    def load(proxy_pac)
      proxy_pac.content = ::File.read(proxy_pac.source).chomp
      proxy_pac.type    = :file
    end

    def suitable_for?(proxy_pac)
      ::File.file? proxy_pac.source
    end
  end

  # Load proxy pac from url
  class ProxyPacUriLoader
    def load(proxy_pac)
      proxy_pac.content = Net::HTTP.get(URI(proxy_pac.source))
      proxy_pac.type = :url
    end

    def suitable_for?(proxy_pac)
      uri = Addressable::URI.parse(proxy_pac.source)

      return true unless uri.host.blank?

      false
    rescue StandardError
      false
    end

    private

    def with_proxy_environment_variables
      backup = []

      %w(
      http_proxy
      https_proxy
      HTTP_PROXY
      HTTPS_PROXY
      ).each do |v|
        backup << ENV.delete(v)
      end

      yield
    ensure
      %w( 
        http_proxy
        https_proxy
        HTTP_PROXY
        HTTPS_PROXY
      ).each do |v|
        ENV[v] = backup.shift
      end
    end
  end
end
