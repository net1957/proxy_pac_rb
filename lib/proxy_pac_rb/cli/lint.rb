# encoding: utf-8
module ProxyPacRb
  module Cli
    # Lint things
    class Lint < Thor
      register(LintProxyPac, 'proxy_pac', 'proxy_pac', 'Lint proxy pac')

      default_command :proxy_pac
    end
  end
end
