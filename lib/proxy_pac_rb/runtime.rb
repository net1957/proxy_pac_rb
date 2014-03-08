module ProxyPacRb
  # Abstract base class for runtimes
  class Runtime
    class Context
      include Encoding

      def initialize(runtime, source = "")
      end

      def exec(source, options = {})
        fail NotImplementedError
      end

      def eval(source, options = {})
        fail NotImplementedError
      end

      def call(properties, *args)
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
