# encoding: utf-8
# frozen_string_literal: true
module ProxyPacRb
  module Cli
    # Shared methods for all cli commands
    module Shared
      # Enable debug mode
      def enable_debug_mode
        ProxyPacRb.enable_debug_mode if options[:debug_mode] == true
      end

      # Remove proxy variables
      def remove_proxy_environment_variables
        %w(
          http_proxy
          https_proxy
          HTTP_PROXY
          HTTPS_PROXY
        ).each do |v|
          ENV.delete(v)
        end
      end
    end
  end
end
