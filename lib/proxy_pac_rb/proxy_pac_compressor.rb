# encoding: utf-8
module ProxyPacRb
  # Compress javascript files
  class ProxyPacCompressor
    def compress(proxy_pac)
      proxy_pac.content = Uglifier.new.compile(proxy_pac.content)
    end
  end
end
