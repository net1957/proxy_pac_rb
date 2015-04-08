module ProxyPacRb
  module Cli
    # Lint things
    class Init < Thor
      register(InitProxyPac, 'proxy_pac', 'proxy_pac', 'Init proxy pac')

      default_command :proxy_pac
    end
  end
end
