module ProxyPacRb
  # Ruby Rhine Runtime
  class RubyRhinoRuntime < Runtime
    # Context
    class Context < Runtime::Context
      def initialize(_runtime, source = '')
        source = encode(source)

        self.context = ::Rhino::Context.new
        fix_memory_limit! context
        context.eval(source)
      end

      def exec(source, options = {})
        source = encode(source)

        return nil unless /\S/ =~ source

        # rubocop:disable Lint/Eval
        eval "(function(){#{source}})()", options
        # rubocop:enable Lint/Eval
      end

      def eval(source, _options = {})
        source = encode(source)

        unbox context.eval("(#{source})") if /\S/ =~ source
      rescue ::Rhino::JSError => e
        if e.message =~ /^syntax error/
          raise e.message
        else
          raise ProgramError, e.message
        end
      end

      def call(properties, *args)
        unbox context.eval(properties).call(*args)
      rescue ::Rhino::JSError => e
        if e.message == 'syntax error'
          raise e.message
        else
          raise ProgramError, e.message
        end
      end

      def unbox(value)
        case value = ::Rhino.to_ruby(value)
        when Java::OrgMozillaJavascript::NativeFunction
          nil
        when Java::OrgMozillaJavascript::NativeObject
          # rubocop:disable Style/EachWithObject
          value.reduce({}) do |vs, (k, v)|
            case v
            when Java::OrgMozillaJavascript::NativeFunction, ::Rhino::JS::Function
              nil
            else
              vs[k] = unbox(v)
            end
            vs
          end
          # rubocop:enable Style/EachWithObject
        when Array
          value.map { |v| unbox(v) }
        else
          value
        end
      end

      private

      # Disables bytecode compiling which limits you to 64K scripts
      def fix_memory_limit!(cxt)
        if cxt.respond_to?(:optimization_level=)
          cxt.optimization_level = -1
        else
          cxt.instance_eval { @native.setOptimizationLevel(-1) }
        end
      end
    end

    def name
      'therubyrhino (Rhino)'
    end

    def available?
      require 'rhino'
      true
    rescue LoadError
      false
    end
  end
end
