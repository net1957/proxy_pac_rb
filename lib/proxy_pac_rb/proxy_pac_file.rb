# encoding: utf-8
module ProxyPacRb
  # Pac file not for parsing
  class ProxyPacFile < ProxyPac
    def content
      read_proxy_pac(path)
    end
  end
end
