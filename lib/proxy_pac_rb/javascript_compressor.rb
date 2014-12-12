# encoding: utf-8
module ProxyPacRb
  class JavascriptCompressor
    def compress(proxy_pac_template)
      proxy_pac_template.compressed_content = Uglifier.new.compile(proxy_pac_template.raw_content)
    end
  end
end
