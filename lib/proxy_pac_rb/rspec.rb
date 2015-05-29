require 'proxy_pac_rb'
require 'rspec'

require 'proxy_pac_rb/rspec/helpers'
ProxyPacRb.require_file_matching_pattern('rspec/matchers/*.rb')
ProxyPacRb.require_file_matching_pattern('rspec/shared_examples/*.rb')
ProxyPacRb.require_file_matching_pattern('rspec/shared_contexts/*.rb')

# Main Module
module ProxyPacRb
  @configuration = CodeConfiguration.new

  class << self
    def configure(&block)
      @configuration.configure(&block)

      @configuration
    end
  end
end

ProxyPacRb.configure do |config|
  config.use_proxy = false
end

RSpec.configure do |config|
  config.include ProxyPacRb::Rspec::Helpers, type: :proxy_pac

  config.before :each do |example|
    next unless self.class.include?(ProxyPacRb::Rspec::Helpers)

    @proxy_pac_rb_config = ProxyPacRb.configure.dup \
      unless defined?(@proxy_pac_rb_config) \
        && @proxy_pac_rb_config.is_a?(ProxyPacRb::CodeConfiguration)

    example.metadata.select { |k,v| k != :proxy_pac_rb_config }.each do |k, v|
      @proxy_pac_rb_config.set_if_option(k, v)
    end

    if @proxy_pac_rb_config.use_proxy == false
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
