module ProxyPacRb
  module Runtimes
    RubyRacer = RubyRacerRuntime.new
    RubyRhino = RubyRhinoRuntime.new

    class << self
      def autodetect
        from_environment || best_available || fail(Exceptions::RuntimeUnavailable, "Could not find a JavaScript runtime. See https://github.com/dg-vrnetze/proxy_pac_rb for a list of runtimes.")
      end

      def from_environment
        if name = ENV["JS_RUNTIME"]
          if runtime = const_get(name)
            if runtime.available?
              runtime if runtime.available?
            else
              fail Exceptions::RuntimeUnavailable, "#{runtime.name} runtime is not available on this system"
            end
          elsif !name.empty?
            fail Exceptions::RuntimeUnavailable, "#{name} runtime is not defined"
          end
        end
      end

      def best_available
        runtimes.find(&:available?)
      end

      def runtimes
        @runtimes ||= [RubyRacer, RubyRhino]
      end
    end
  end

  def self.runtimes
    Runtimes.runtimes
  end
end
