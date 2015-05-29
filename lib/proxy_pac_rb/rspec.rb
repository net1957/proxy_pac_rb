require 'proxy_pac_rb'
require 'rspec'

require 'proxy_pac_rb/rspec/helpers'
require 'proxy_pac_rb/rspec/configuration'
ProxyPacRb.require_file_matching_pattern('rspec/matchers/*.rb')
ProxyPacRb.require_file_matching_pattern('rspec/shared_examples/*.rb')
ProxyPacRb.require_file_matching_pattern('rspec/shared_contexts/*.rb')

# Main Module
module ProxyPacRb
  # Main Module
  module Rspec
    @configuration = Configuration.new

    class << self
      def configure(&block)
        @configuration.configure(&block)

        @configuration
      end
    end
  end
end

ProxyPacRb::Rspec.configure do |config|
  config.use_proxy = false
end

RSpec.configure do |config|
  config.include ProxyPacRb::Rspec::Helpers, type: :proxy_pac

  current_example  = context.example
  current_metadata = current_example.metadata

  config.before :each do
  binding.pry
    next unless self.class.include?(ProxyPacRb::Rspec::Helpers)

    current_metadata[:proxy_pac_rb_config] = ProxyPacRb::Rspec.configure.dup \
      unless current_metadata.key?(:proxy_pac_rb_config) \
        && current_metadata[:proxy_pac_rb_config].is_a?(ProxyPacRb::Rspec::Configuration)

    current_config   = current_metadata[:proxy_pac_rb_config]

    current_metadata.select { |k,v| k != :proxy_pac_rb_config }.each do |k, v|
      current_config.set_if_option(k, v)
    end

    if current_config.use_proxy == true
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
