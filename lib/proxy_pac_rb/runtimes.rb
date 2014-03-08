module ProxyPacRb
  module Runtimes
    RubyRacer = RubyRacerRuntime.new
    RubyRhino = RubyRhinoRuntime.new

    class << self
      def autodetect
        from_environment || best_available ||
          raise(Exceptions::RuntimeUnavailable, "Could not find a JavaScript runtime. " +
                "See https://github.com/sstephenson/execjs for a list of available runtimes.")
      end

      def best_available
        runtimes.reject(&:deprecated?).find(&:available?)
      end

      def from_environment
        if name = ENV["EXECJS_RUNTIME"]
          if runtime = const_get(name)
            if runtime.available?
              runtime if runtime.available?
            else
              raise Exceptions::RuntimeUnavailable, "#{runtime.name} runtime is not available on this system"
            end
          elsif !name.empty?
            raise Exceptions::RuntimeUnavailable, "#{name} runtime is not defined"
          end
        end
      end

      def names
        @names ||= constants.inject({}) { |h, name| h.merge(const_get(name) => name) }.values
      end

      def runtimes
        @runtimes ||= [
          RubyRacer,
          RubyRhino,
        ]
      end
    end

    def runtimes
      Runtimes.runtimes
    end
  end
end
