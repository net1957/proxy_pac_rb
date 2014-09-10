module ProxyPacRb
  # JavaScript Runtimes
  module Runtimes
    RubyRacer = RubyRacerRuntime.new
    RubyRhino = RubyRhinoRuntime.new

    class << self
      def autodetect
        from_environment || best_available ||
          fail(Exceptions::RuntimeUnavailable, 'Could not find a JavaScript runtime. ' \
                'See https://github.com/sstephenson/execjs for a list of available runtimes.')
      end

      def best_available
        runtimes.reject(&:deprecated?).find(&:available?)
      end

      def from_environment
        return nil unless ENV['JS_RUNTIME']

        runtime = const_get(ENV['JS_RUNTIME'])

        fail Exceptions::RuntimeUnavailable, "#{ENV['JS_RUNTIME']} runtime is not defined" unless runtime
        fail Exceptions::RuntimeUnavailable, "#{runtime.name} runtime is not available on this system" unless runtime.available?

        runtime
      end

      def names
        @names ||= constants.reduce({}) { |h, name| h.merge(const_get(name) => name) }.values
      end

      def runtimes
        @runtimes ||= [
          RubyRacer,
          RubyRhino
        ]
      end
    end

    def runtimes
      Runtimes.runtimes
    end
  end
end
