module Namedrb
  # Resolve names via dns
  class NameResolver
    private

    attr_reader :resolvers

    public

    class DefaultResolver
      private

      attr_reader :resolver

      public

      def match?(*)
        true
      end

      def resolve(input)
        fail InvalidNameError, %(Name "#{input.join(", ")}" is invalid.)
      end
    end

    class DnsNameResolver
      private

      attr_reader :resolver

      public

      def initialize(
        resolver: Resolv::DNS.new
      )
        @resolver = resolver
      end

      def match?(input)
        %r{
        \A
        (
          (
            [a-zA-Z0-9]
            | [a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9]
          )
          \.
        )*
          (
            [A-Za-z0-9]
        |[A-Za-z0-9][A-Za-z0-9\-]*[A-Za-z0-9]
        )
          \Z
          }m === input
      end

      def resolve(input)
        resolver.getaddresses(input)
      end
    end

    class IpAddressResolver
      private

      attr_reader :resolver

      public

      def initialize(
        resolver: Resolv::DNS.new
      )
        @resolver = resolver
      end

      def match?(input)
        IPAddr.new(input)

        true
      rescue StandardError
        return false
      end

      def resolve(input)
        resolver.getnames(input)
      end
    end

    attr_reader :timeout

    def initialize(
      timeout: 2
    )
      @resolvers = []
      @resolvers << IpAddressResolver.new
      @resolvers << DnsNameResolver.new
      @resolvers << DefaultResolver.new

      @timeout = timeout
    end

    def resolve(input)
      Timeout.timeout(timeout) do
        resolvers.find { |r| r.match?(input) }.resolve(input)
      end
    end
  end
end
