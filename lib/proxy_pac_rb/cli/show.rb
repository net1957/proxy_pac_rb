# encoding: utf-8
# frozen_string_literal: true
module ProxyPacRb
  module Cli
    # Show things
    class Show < Thor
      desc 'version', 'Show version'
      def version
        $stderr.puts ProxyPacRb::VERSION
      end

      default_command :version
    end
  end
end
