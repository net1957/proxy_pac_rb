# encoding: utf-8
module ProxyPacRb
  module Cli
    # Compress things
    class Compress < Thor
      register(CompressProxyPac, 'proxy_pac', 'proxy_pac', 'Compress proxy pac')

      default_command :proxy_pac
    end
  end
end
