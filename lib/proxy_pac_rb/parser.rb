# encoding: utf-8
module ProxyPacRb
  class Parser

    private

    attr_reader :runtime, :environment

    public

    def initialize(environment = Environment.new, runtime = Runtimes.autodetect)
      fail Exceptions::RuntimeUnavailable, "#{runtime.name} is unavailable on this system" unless runtime.available?

      @runtime     = runtime
      @environment = environment
    end

    def load(url, options = {})
      create_file(open(url, { :proxy => false }.merge(options)).read)
    end

    def read(file)
      create_file(::File.read(file))
    end

    def source(source)
      create_file(source)
    end

    private

    def compile_javascript(source)
      environment.prepare(source)

      context = runtime.compile(source)
      context.include environment

      context
    end

    def create_file(source)
      File.new(compile_javascript(source))
    end
  end
end
