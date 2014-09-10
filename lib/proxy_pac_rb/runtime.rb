module ProxyPacRb
  # Abstract base class for runtimes
  class Runtime
    class Context
      include Encoding

      attr_accessor :context

      def include(environment)
        environment.available_methods.each do |name|
          context[name] = environment.method(name)
        end
      end

      def initialize(_runtime, _source = '')
      end

      def exec(_source, _options = {})
        fail NotImplementedError
      end

      def eval(_source, _options = {})
        fail NotImplementedError
      end

      def call(_properties, *_args)
        fail NotImplementedError
      end
    end

    def name
      fail NotImplementedError
    end

    def context_class
      self.class::Context
    end

    def exec(source)
      context = context_class.new(self)
      context.exec(source)
    end

    def eval(source)
      context = context_class.new(self)
      context.eval(source)
    end

    def compile(source)
      context_class.new(self, source)
    end

    def deprecated?
      false
    end

    def available?
      fail NotImplementedError
    end
  end
end
