# frozen_string_literal: true
require 'proxy_pac_rb/rack/proxy_pac_linter'
use ProxyPacRb::Rack::ProxyPacLinter

require 'proxy_pac_rb/rack/proxy_pac_compressor'
use ProxyPacRb::Rack::ProxyPacCompressor

page '*.pac', content_type: 'application/x-ns-proxy-autoconfig'

Dir.glob(File.join(source_dir, '**', '*.pac')).each do |f|
  relative_path = Pathname.new(f).relative_path_from(Pathname.new(source_dir))
  proxy(format('%s.raw', relative_path), relative_path.to_s, content_type: 'text/plain')
end
