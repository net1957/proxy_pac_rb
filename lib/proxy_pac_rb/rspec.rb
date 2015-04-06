require 'proxy_pac_rb'
require 'rspec'

require 'proxy_pac_rb/rspec/helpers'
ProxyPacRb.require_file_matching_pattern('proxy_pac_rb/rspec/shared_examples/*.rb')
ProxyPacRb.require_file_matching_pattern('proxy_pac_rb/rspec/shared_contexts/*.rb')

# Main Module
module ProxyPacRb
  # Main Module
  module Rspec
  end
end

RSpec.configure do |config|
  config.include ProxyPacRb::Rspec::Helpers, type: :proxy_pac
end
