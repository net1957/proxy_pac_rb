# encoding: utf-8
module ProxyPacRb
  # Commandline parsing
  module Cli
    # Run command
    class Runner < Thor
      map '-v' => :version
      map '--version' => :version

      class_option :debug_mode, type: :boolean, default: false, desc: 'Enable debug mode'

      desc 'find', 'Find something'
      subcommand 'find', Find

      desc 'compress', 'Compress something'
      subcommand 'compress', Compress

      desc 'show', 'Show something'
      subcommand 'show', Show

      desc 'lint', 'Lint something'
      subcommand 'lint', Lint

      desc 'version', 'version', hide: true
      def version
        invoke 'proxy_pac_rb:cli:show:version'
      end
    end
  end
end
