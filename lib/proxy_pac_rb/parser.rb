# encoding: utf-8
module ProxyPacRb
  class Parser

    class << self
      attr_reader :runtime

      def runtime=(runtime)
        fail Exceptions::RuntimeUnavailable, "#{runtime.name} is unavailable on this system" unless runtime.available?

        @runtime = runtime
      end

      def load(url, options = {})
        File.new(open(url, { :proxy => false }.merge(options)).read)
      end

      def read(file)
        File.new(::File.read(file))
      end

      def source(source)
        File.new(source)
      end
    end

    self.runtime = Runtimes.autodetect
  end
end
