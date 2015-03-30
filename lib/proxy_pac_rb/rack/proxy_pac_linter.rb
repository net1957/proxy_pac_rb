require 'proxy_pac_rb'
require 'rack'

module ProxyPacRb
  module Rack
    # Rack Middleware to lint proxy pac
    #
    # @example Sinatra's <server>.rb
    # require 'proxy_pac_rb/rack/proxy_pac_linter'
    # use ProxyPacRb::Rack::ProxyPacLinter
    #
    # @example Rack's config.ru
    # require 'proxy_pac_rb/rack/proxy_pac_linter'
    # use ProxyPacRb::Rack::ProxyPacLinter
    #
    # @example Middleman's config.rb
    # require 'proxy_pac_rb/rack/proxy_pac_linter'
    # use ProxyPacRb::Rack::ProxyPacLinter
    class ProxyPacLinter
      private

      attr_reader :linter, :loader, :enabled

      public

      def initialize(
        app,
        enabled: true
      )
        @app     = app
        @linter  = ProxyPacRb::ProxyPacLinter.new(silent: true)
        @loader  = ProxyPacRb::ProxyPacLoader.new
        @enabled = enabled
      end

      def call(env)
        status, headers, body = @app.call(env)

        return [status, headers, body] if enabled == false
        # rubocop:disable Style/CaseEquality
        return [status, headers, body] unless headers.key?('Content-Type') \
                                              && %r{application/x-ns-proxy-autoconfig} === headers['Content-Type']
        # rubocop:enable Style/CaseEquality

        content = ''
        content = body.each { |part| content << part }

        proxy_pac = ProxyPacFile.new(source: content)

        loader.load(proxy_pac)
        linter.lint(proxy_pac)

        unless proxy_pac.valid?
          status  = 500
          body = proxy_pac.message
          headers['Content-Length'] = body.bytesize.to_s if headers['Content-Length']
        end

        [status, headers, [body]]
      ensure
        body.close if body.respond_to?(:close)
      end
    end
  end
end
