# encoding: utf-8
module ProxyPacRb
  # Dump Proxy pac to file system
  class ProxyPacDumper
    def dump(content:, file:)
      ::File.write(file, content)
    end
  end
end
