module ProxyPacRb
  module Rspec
    module Helpers
      def proxy_pac
        source = if subject.nil? || Addressable::URI.parse(subject).host || /FindProxyForURL/ === subject
                   subject
                 else
                   File.join(root_path, subject)
                 end

        file = ProxyPacRb::ProxyPacFile.new(source: source)

        _proxy_pac_loader.load(file)
        _proxy_pac_linter.lint(file)
        _proxy_pac_parser.parse(file)

        file
      end

      private

      def root_path
        @root_path ||= Dir.getwd
      end

      def _proxy_pac_parser
        ProxyPacRb::ProxyPacParser.new
      end

      def _proxy_pac_loader
        ProxyPacRb::ProxyPacLoader.new
      end

      def _proxy_pac_linter
        ProxyPacRb::ProxyPacLinter.new
      end
    end
  end
end
