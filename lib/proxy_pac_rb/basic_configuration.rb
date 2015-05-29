module ProxyPacRb
  # Basic configuration for ProxyPacRb
  class BasicConfiguration
    include Contracts

    class Option
      attr_accessor :name, :value

      def initialize(name:, value:)
        @name = name
        @value = value
      end
    end

    class << self
      def options
        @options ||= Set.new
      end

      def option_writer(name, contract:, default:)
        opt = find_or_add_option(name, default)
        opt.value = default

        Contract contract
        define_method("#{name}=") { |v| opt.value = v }

        self
      end

      def option_reader(name)
        opt = find_or_add_option(name)
        define_method("#{name}") { opt.value }

        self
      end

      def option(name, contract:, default:)
        option_writer name, contract: contract, default: default
        option_reader name
      end

      private

      def find_or_add_option(name, value = nil)
        opt = options.find(->{ Option.new(name: name, value: value) }) { |o| o.name == name }
        options << opt

        opt
      end
    end

    def initialize
      after_initialize
    end

    def after_initialize; end

    # @yield [Configuration]
    #
    #   Yields self
    def configure
      yield self if block_given?
    end

    def options
      self.class.options
    end

    def option?(name)
      options.any? { |o| o.name == name }
    end

    # Set if name is option
    def set_if_option(name, *args)
      public_send("#{name}=".to_sym, *args) if option? name
    end
  end
end
