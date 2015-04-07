# encoding: utf-8
module ProxyPacRb
  module Cli
    # Compress proxy pac
    class CompressProxyPac < Thor::Group
      include Shared

      class_option :proxy_pac, type: :array, desc: 'Proxy.pac-file(s)', aliases: '-p', required: true

      def pre_init
        enable_debug_mode
      end

      def set_variables
        @proxy_pacs = options[:proxy_pac].map { |p| ProxyPacFile.new source: p }
        @compressor = ProxyPacCompressor.new
        @dumper     = ProxyPacDumper.new
        @loader     = ProxyPacLoader.new
        @linter     = ProxyPacLinter.new
      end

      def load_files
        @proxy_pacs.each { |p| @loader.load(p) }
      end

      def test_proxy_pac
        @proxy_pacs.keep_if do |p|
          @linter.lint(p)

          if p.valid?
            true
          else
            $stderr.puts %(proxy.pac "#{p.source}" is of type #{p.type} and is invalid: #{p.message}. I'm going to ignore that file.)

            false
          end
        end
      end

      def compress_proxy_pac
        @proxy_pacs.each do |p|
          @compressor.compress(p)
          @dumper.dump(p, type: :template)
        end
      end
    end
  end
end
