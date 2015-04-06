module ProxyPacRb
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

      environment.prepare(content)

      context = runtime.compile(content)
      context.include environment

      Javascript.new(context)
    rescue StandardError => err
      raise CompilerError, err.message
    end
  end
end
