# encoding: utf-8
module ProxyPacRb
  module Cli
    # Find things
    class Find < Thor
      register(FindProxy, 'proxy', 'proxy', 'Find proxy for URL(s)')

      default_command :proxy
    end
  end
end
