module ProxyPacRb
  # Basic configuration for ProxyPacRb
  class BasicConfiguration
    include Contracts

    # A configuration option
    class Option
      attr_accessor :name, :value

      def initialize(name:, value:)
        @name  = name
        @value = value
      end
    end

    class << self
      def known_options
        @known_options ||= {}
      end

      def option_writer(name, contract:, default:)
        add_option(name, default)

        Contract contract
        define_method("#{name}=") { |v| find_option(name).value = v }

        self
      end

      def option_reader(name, value: nil)
        add_option(name, value)

        define_method(name) { find_option(name).value }

        self
      end

      def option(name, contract:, default:)
        option_writer name, contract: contract, default: default
        option_reader name
      end

      private

      def add_option(name, value = nil)
        return if known_options.key?(name)

        known_options[name] = Option.new(name: name, value: value)

        self
      end
    end

    attr_reader :local_options
    private :local_options

    def initialize
      @local_options = self.class.known_options.deep_dup
    end

    # @yield [Configuration]
    #
    #   Yields self
    def configure
      yield self if block_given?
    end

    def option?(name)
      local_options.any? { |_, v| v.name == name }
    end

    # Set if name is option
    def set_if_option(name, *args)
      public_send("#{name}=".to_sym, *args) if option? name
    end

    private

    def find_option(name)
      fail NotImplementedError, %(Unknown option "#{name}") unless option? name

      local_options[name]
    end
  end
end
