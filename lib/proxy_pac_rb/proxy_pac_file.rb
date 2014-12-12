# encoding: utf-8
module ProxyPacRb
  class ProxyPacFile < ProxyPac
    def content
      read_proxy_pac(path)
    end
  end
end
