module ProxyPacRb
  # Ruby Racer Runtime
  class RubyRacerRuntime < Runtime
    # Context
    class Context < Runtime::Context
      def initialize(_runtime, source = '', _environment = nil)
        source = encode(source)

        lock do
          self.context = ::V8::Context.new
          context.eval(source)
        end
      end

      def exec(source, options = {})
        source = encode(source)

        # rubocop:disable Lint/Eval
        eval "(function(){#{source}})()", options if /\S/ =~ source
        # rubocop:enable Lint/Eval
      end

      def eval(source, _options = {})
        source = encode(source)

        return nil unless /\S/ =~ source

        lock do
          begin
            unbox context.eval("(#{source})")
          rescue ::V8::JSError => e
            if e.value['name'] == 'SyntaxError'
              raise e.value.to_s
            else
              raise ProgramError, e.value.to_s
            end
          end
        end
      end

      def call(properties, *args)
        lock do
          begin
            unbox context.eval(properties).call(*args)
          rescue ::V8::JSError => e
            if e.value['name'] == 'SyntaxError'
              raise e.value.to_s
            else
              raise ProgramError, e.value.to_s
            end
          end
        end
      end

      def unbox(value)
        case value
        when ::V8::Function
          nil
        when ::V8::Array
          value.map { |v| unbox(v) }
        when ::V8::Object
          # rubocop:disable Style/EachWithObject
          value.reduce({}) do |vs, (k, v)|
            vs[k] = unbox(v) unless v.is_a?(::V8::Function)
            vs
          end
          # rubocop:enable Style/EachWithObject
        when String
          if value.respond_to?(:force_encoding)
            value.force_encoding('UTF-8')
          else
            value
          end
        else
          value
        end
      end

      private

      def lock
        result, exception = nil, nil
        V8::C::Locker() do
          begin
            result = yield
          rescue => e
            exception = e
          end
        end

        if exception
          fail exception
        else
          result
        end
      end
    end

    def name
      'therubyracer (V8)'
    end

    def available?
      require 'v8'
      true
    rescue LoadError
      false
    end
  end
end
