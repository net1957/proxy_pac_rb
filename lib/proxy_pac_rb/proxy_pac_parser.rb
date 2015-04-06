# encoding: utf-8
module ProxyPacRb
  # Parse Proxy pac to file system
  class ProxyPacParser
    private

    attr_reader :environment, :runtime, :compiler

    public

    def initialize(
      environment: Environment.new,
      compiler: JavascriptCompiler.new
    )
      @environment = environment
      @compiler    = compiler
    end

    def parse(proxy_pac)
      message = "It does not make sense to parse invalid proxy.pac \"#{proxy_pac.source}\": #{proxy_pac.message}" 
      fail ParserError, message unless proxy_pac.valid?

      proxy_pac.javascript = compiler.compile(content: proxy_pac.content, environment: environment)
    rescue => err
      raise ParserError, err.message
    end
  end
end
