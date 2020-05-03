# frozen_string_literal: true
module ProxyPacRb
  # Duktape Runtime
  # little adaptation from execjs gem.
  # All credits go to execjs gem author
  class DuktapeRuntime < Runtime
    # Context
    class Context < Runtime::Context
      def initialize(_runtime, source = '', _environment = nil)
        source = encode(source)

        self.context = ::Duktape::Context.new(complex_object: nil)
        context.exec_string(source, '(proxypacrb)')
      rescue StandardError => e
        raise wrap_error(e)
      end

      def include(environment)
        environment.available_methods.each do |name|
          context.define_function(name.to_s, &environment.method(name))
        end
      end

      def exec(source, _options = {})
        source = encode(source)

        context.eval_string("(function(){#{source}})()", '(proxypacrb)') if /\S/ =~ source
      rescue StandardError => e
        raise wrap_error(e)
      end

      def eval(source, _options = {})
        source = encode(source)

        return nil unless /\S/ =~ source

        context.eval_string("(#{source})", '(proxypacrb)')
      rescue StandardError => e
        raise wrap_error(e)
      end

      def call(identifier, *args)
        x = context.call_prop(identifier.to_s.split('.'), *args)
        x
      rescue StandardError => e
        raise wrap_error(e)
      end

      private

      def wrap_error(err)
        klass = case err
                when Duktape::SyntaxError
                  RuntimeError
                when Duktape::Error
                  ProgramError
                when Duktape::InternalError
                  RuntimeError
                end

        if klass
          re = / \(line (\d+)\)$/
          lineno = err.message[re, 1] || 1
          error = klass.new(err.message.sub(re, ''))
          error.set_backtrace(["(proxypacrb):#{lineno}"] + err.backtrace)
          error
        else
          err
        end
      end
    end

    def name
      'Duktape'
    end

    def available?
      require 'duktape'
      true
    rescue LoadError
      false
    end
  end
end
