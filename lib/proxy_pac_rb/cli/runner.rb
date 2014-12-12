# encoding: utf-8
module ProxyPacRb
  module Cli
    class Runner < Thor
      map '-v' => :version
      map '--version' => :version

      desc 'find', 'Find something'
      subcommand 'find', Find

      desc 'show', 'Show something'
      subcommand 'show', Show

      desc 'version', 'version', hide: true
      def version
        invoke 'proxy_pac_rb:cli:show:version'
      end
    end
  end
end
