# encoding: utf-8
module ProxyPacRb
  module Cli
    class Find < Thor
      register(FindProxy, 'proxy', 'find_proxy URLS', 'Find proxy for URL(s)')

      default_command :proxy
    end
  end
end
