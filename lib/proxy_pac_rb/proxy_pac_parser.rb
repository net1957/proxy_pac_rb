# encoding: utf-8
module ProxyPacRb
  # Parse Proxy pac to file system
  class ProxyPacParser
    private

    attr_reader :environment, :runtime

    public

    def initialize(
      environment: Environment.new,
      runtime: Runtimes.autodetect
    )
      @runtime     = runtime
      @environment = environment
    end

    def parse(proxy_pac)
      fail Exceptions::RuntimeUnavailable, "#{runtime.name} is unavailable on this system" unless runtime.available?

      ProxyPac.new(
        javascript: compile_javascript(proxy_pac.content),
        file: proxy_pac
      )
    end

    private

    def compile_javascript(content)
      environment.prepare(content)

      context = runtime.compile(content)
      context.include environment

      Javascript.new(context)
    rescue StandardError => err
      raise ParserError, err.message
    end
  end
end
