# encoding: utf-8
module ProxyPacRb
  # Compress javascript files
  class ProxyPacCompressor
    def compress(file)
      file.compressed_content = Uglifier.new.compile(file.raw_content)
    end

    def modify(proxy_pac_file)
      proxy_pac_file.content = Uglifier.new.compile(proxy_pac_file.content)
    end
  end
end
