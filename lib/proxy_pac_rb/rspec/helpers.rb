module ProxyPacRb
  module Rspec
    # Helpers for proxy.pac tests
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

      def time
        '1970-01-01 00:00:00'
      end

      def client_ip
        '127.0.0.1'
      end

      def root_path
        @root_path ||= Dir.getwd
      end

      private

      def _environment
        Environment.new(time: time, client_ip: client_ip)
      end

      def _proxy_pac_parser
        ProxyPacRb::ProxyPacParser.new(environment: _environment)
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
