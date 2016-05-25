# encoding: utf-8
# frozen_string_literal: true
module ProxyPacRb
  # Dump Proxy pac to file system
  class ProxyPacLoader
    private

    attr_reader :loaders, :default_loader

    public

    def initialize
      @loaders = []
      @loaders << ProxyPacStringLoader.new
      @loaders << ProxyPacUriLoader.new
      @loaders << ProxyPacFileLoader.new
      @loaders << ProxyPacNullLoader.new

      @default_loader = -> { ProxyPacNullLoader.new }
    end

    # Load proxy pac
    #
    # @param [#source] proxy_pac
    #   The proxy.pac
    def load(proxy_pac)
      return if proxy_pac.content?

      loaders.find(default_loader) { |l| l.suitable_for? proxy_pac }.load(proxy_pac)

      proxy_pac.readable = true
    rescue => err
      proxy_pac.message = err.message
      proxy_pac.readable = false
    end
  end

  # Load proxy pac from string
  class ProxyPacStringLoader
    def load(proxy_pac)
      proxy_pac.content = proxy_pac.source.to_s.chomp
      proxy_pac.type = :string

      self
    end

    def suitable_for?(proxy_pac)
      return false if proxy_pac.nil? || proxy_pac.source.nil?

      proxy_pac.source.include? 'FindProxyForURL'
    end
  end

  # Handle proxy pac == nil
  class ProxyPacNullLoader
    def load(proxy_pac)
      proxy_pac.type = :null

      raise StandardError
    end

    def suitable_for?(proxy_pac)
      proxy_pac.nil?
    end
  end

  # Load proxy pac from file
  class ProxyPacFileLoader
    def load(proxy_pac)
      content = ::File.read(proxy_pac.source.to_s).chomp

      proxy_pac.content = content
      proxy_pac.type    = :file
    end

    def suitable_for?(proxy_pac)
      return false if proxy_pac.nil? || proxy_pac.source.nil?

      path = Pathname.new(proxy_pac.source)

      path.relative? || path.absolute?
    end
  end

  # Load proxy pac from url
  class ProxyPacUriLoader
    def load(proxy_pac)
      proxy_pac.content = download_proxy_pac(proxy_pac.source.to_s)
      proxy_pac.type    = :url
    end

    def suitable_for?(proxy_pac)
      return false if proxy_pac.nil? || proxy_pac.source.nil?

      uri = Addressable::URI.parse(proxy_pac.source)

      return true unless uri.host.blank?

      false
    rescue StandardError
      false
    end

    private

    def download_proxy_pac(url)
      Excon.defaults[:middlewares] << Excon::Middleware::RedirectFollower
      Excon.get(url).body.chomp
    end
  end
end
