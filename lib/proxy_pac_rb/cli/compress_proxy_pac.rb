# encoding: utf-8
module ProxyPacRb
  module Cli
    # Find proxy for url
    class CompressProxyPac < Thor::Group
      include Shared

      class_option :proxy_pac, type: :array, desc: 'Proxy.pac-file(s)', aliases: '-p', required: true

      def set_variables
        @proxy_pacs = options[:proxy_pac].map { |p| ProxyPacTemplate.new(p) }
        @compressor = ProxyPacCompressor.new
      end

      def test_proxy_pac
        @proxy_pacs.each do |p|
          begin
            file = ProxyPacRb::Parser.new.source(p.raw_content)
            file.find('http://example.org')
          rescue V8::Error => e
            $stderr.puts "Proxy.pac-file \"#{p.input_path}\" is invalid. I ignore that file: #{e.message}"
          end
        end
      end

      def compress_proxy_pac
        @proxy_pacs.each do |p|
          p.compress_me(@compressor)
          p.write
        end
      end
    end
  end
end
