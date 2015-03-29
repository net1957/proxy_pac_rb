# encoding: utf-8
module ProxyPacRb
  # Dump Proxy pac to file system
  class ProxyPacLinter
    private

    attr_reader :rules, :silent

    public
    def initialize(silent: false)
      @rules = []
      @rules << Rules::ContainerProxyPacFunction.new
      @rules << Rules::CanBeCompiled.new

      @silent = silent
    end

    # Load proxy pac
    #
    # @param [#source] proxy_pac
    #   The proxy.pac
    def lint(proxy_pac)
      rules.each { |r| r.lint(proxy_pac) }

      proxy_pac.valid = true
    rescue LinterError => err
      $stderr.puts err.message unless silent

      proxy_pac.valid = false
    end
  end

  module Rules
    class ContainerProxyPacFunction
      def lint(proxy_pac)
        message = %(proxy.pac "#{proxy_pac.source}" does not contain "FindProxyForURL".)

        fail LinterError, message unless proxy_pac.content.include?('FindProxyForURL')

        self
      end
    end

    class CanBeCompiled
      private

      attr_reader :parser

      public

      def initialize
        @parser = ProxyPacParser.new
      end

      def lint(proxy_pac)
        parser.parse(proxy_pac)

        self
      rescue => err
        raise LinterError, %(proxy.pac "#{proxy_pac.source}" cannot be compiled:\n#{err.message}".)
      end
    end
  end
end
