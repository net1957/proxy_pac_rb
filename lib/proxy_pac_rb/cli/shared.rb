# encoding: utf-8
module ProxyPacRb
  module Cli
    # Shared methods for all cli commands
    module Shared
      # Enable debug mode
      def enable_debug_mode
        ProxyPacRb.enable_debug_mode if options[:debug_mode] == true
      end
    end
  end
end
