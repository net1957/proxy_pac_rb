# encoding: utf-8
module ProxyPacRb
  module Cli
    class Show < Thor
      desc 'version', 'Show version'
      def version
        $stderr.puts ProxyPacRb::VERSION
      end

      default_command :version
    end
  end
end
