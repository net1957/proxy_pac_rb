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
      @rules << Rules::CanBeParsed.new

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

      proxy_pac.message = err.message
      proxy_pac.valid = false
    end
  end

  module Rules
    class ContainerProxyPacFunction
      def lint(proxy_pac)
        message = if proxy_pac.type? :string
                    %(proxy.pac is only given as string "#{proxy_pac.source}" and does not contain "FindProxyForURL".)
                  elsif proxy_pac.type? :url
                    %(proxy.pac-url "#{proxy_pac.source}" does not contain "FindProxyForURL".)
                  else
                    %(proxy.pac-file "#{proxy_pac.source}" does not contain "FindProxyForURL".)
                  end

        fail LinterError, message unless proxy_pac.content.include?('FindProxyForURL')

        self
      end
    end

    class CanBeParsed
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
        message = if proxy_pac.type? :string
                    %(proxy.pac is only given as string "#{proxy_pac.source}" cannot be parsed:\n#{err.message}".)
                  elsif proxy_pac.type? :url
                    %(proxy.pac-url "#{proxy_pac.source}" cannot be parsed:\n#{err.message}".)
                  else
                    %(proxy.pac-file "#{proxy_pac.source}" cannot be parsed:\n#{err.message}".)
                  end

        raise LinterError, message
      end
    end
  end
end
