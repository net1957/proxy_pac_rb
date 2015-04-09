module ProxyPacRb
  # Compile javascript
  class JavascriptCompiler
    private

    attr_reader :runtime

    public

    def initialize(
      runtime: Runtimes.autodetect
    )
      @runtime = runtime
    end

    def compile(content:, environment:)
      fail Exceptions::RuntimeUnavailable, "#{runtime.name} is unavailable on this system" unless runtime.available?

      proxy_pac_content = content.to_s.dup

      environment.prepare(proxy_pac_content)

      context = runtime.compile(proxy_pac_content)
      context.include environment

      Javascript.new(context)
    rescue StandardError => err
      raise CompilerError, err.message
    end
  end
end
