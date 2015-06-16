require 'proxy_pac_rb'

module ProxyPacRb
  # RSpec matchers
  module RSpecMatchers
    # Check if other proxy pac the same
    class BeTheSameProxyPacFile < BaseMatcher
      def initialize(expected)
        @file_a = begin
                      file = ProxyPacRb::ProxyPacFile.new(source: expected)
                      loader.load(file)

                      file
                    end

        @expected = @file_a.content
      end

      def matches?(actual)
        @file_b = begin
                    file = ProxyPacRb::ProxyPacFile.new(source: actual)
                    loader.load(file)

                    file
                  end

        @actual = @file_b.content

        values_match?(@expected, @actual)
      end

      def diffable?
        true
      end

      def failure_message
        format(%(expected that proxy.pac "%s" is equal to proxy.pac "%s", but it is not.), @file_a.source.truncate(30), @file_b.source.truncate(30))
      end

      def failure_message_when_negated
        format(%(expected that proxy.pac "%s" is not equal to proxy.pac "%s", but it is the same.), @file_a.source.truncate(30), @file_b.source.truncate(30))
      end

      private

      def loader
        @loader ||= ProxyPacRb::ProxyPacLoader.new
      end
    end
  end
end

# External documented
module RSpec
  # External documented
  module Matchers
    # Check proxy pac
    #
    # @param [RSpec::Matcher] expected
    #    The matcher
    def be_the_same_proxy_pac_file(expected)
      ProxyPacRb::RSpecMatchers::BeTheSameProxyPacFile.new(expected)
    end
  end
end
