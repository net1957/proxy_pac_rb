module ProxyPacRb
  module Rspec
    # Configure ProxyPacRb
    class Configuration
      include Contracts

      @options = Set.new

      class << self
        attr_reader :options

        def option_writer(name, contract)
          Contract contract
          attr_writer name
          options << name
        end

        def option_reader(name)
          attr_reader name
          options << name
        end

        def option(name, contract)
          option_writer name, contract
          option_reader name
        end
      end

      def initialize
        @use_proxy = false
      end

      # @yield [Configuration]
      #
      #   Yields self
      def configure
        yield self if block_given?
      end

      def option?(name)
        self.class.options.include? name.to_sym
      end

      # Set if name is option
      def set_if_option(name, *args)
        public_send("#{name}=".to_sym, *args) if option? name
      end

      option :use_proxy, Bool => Bool
    end
  end
end
