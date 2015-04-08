module ProxyPacRb
  module Cli
    # Find proxy for url
    class LintProxyPac < Thor::Group
      include Shared

      class_option :proxy_pac, type: :array, desc: 'Proxy.pac-file(s)', aliases: '-p', required: true

      def pre_init
        enable_debug_mode
      end

      def set_variables
        @proxy_pacs = options[:proxy_pac].map { |p| ProxyPacFile.new source: p }
        @loader     = ProxyPacLoader.new
        @linter     = ProxyPacLinter.new
      end

      def test_proxy_pac
        @proxy_pacs.each do |p|
          @loader.load(p)
          @linter.lint(p)

          if p.valid?
            $stderr.puts %(proxy.pac "#{p.source}" is of type #{p.type} and is valid.)
            true
          else
            $stderr.puts %(proxy.pac "#{p.source}" is of type #{p.type} and is invalid.)

            false
          end
        end
      end
    end
  end
end
