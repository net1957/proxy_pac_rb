# frozen_string_literal: true
module ProxyPacRb
  # Mini Racer Runtime
  class MiniRacerRuntime < Runtime
    # Context
    class Context < Runtime::Context
      def initialize(_runtime, source = '', _environment = nil)
        source = encode(source)

        self.context = ::MiniRacer::Context.new
        context.eval(source)
      end

      def include(environment)
        environment.available_methods.each do |name|
          context.attach(name.to_s, environment.method(name))
        end
      end

      def exec(source, options = {})
        source = encode(source)

        # rubocop:disable Security/Eval, Style/EvalWithLocation
        eval "(function(){#{source}})()", options if /\S/ =~ source
        # rubocop:enable Security/Eval, Style/EvalWithLocation
      end

      def eval(source, _options = {})
        source = encode(source)

        return nil unless /\S/ =~ source

        begin
          unbox context.eval("(#{source})")
        rescue MiniRacer::Error => e
          raise ProgramError, e
        end
      end

      def call(properties, *args)
        unbox context.eval("#{properties}.apply(this, #{::JSON.generate(args)})")
      rescue MiniRacer::Error => e
        raise ProgramError, e
      end

      def unbox(value)
        if Array === value
          value.map! do |v|
            if MiniRacer::JavaScriptFunction === value
              nil
            else
              unbox(v)
            end
          end
        elsif Hash === value
          value.each do |k, v|
            if MiniRacer::JavaScriptFunction === v
              value.delete k
            else
              value[k] = unbox(v)
            end
          end
          value
        elsif MiniRacer::JavaScriptFunction === value
          nil
        else
          value
        end
      end
    end

    def name
      'mini_racer (V8)'
    end

    def available?
      require 'mini_racer'
      true
    rescue LoadError
      false
    end
  end
end
