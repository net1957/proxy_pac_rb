require 'proxy_pac_rb'

require 'proxy_pac_rb/rspec/version'
require 'proxy_pac_rb/rspec/helpers'

# Main Module
module ProxyPacRb
  # Main Module
  module Rspec
  end
end

RSpec.configure do |config|
  config.include ProxyPacRb::Rspec::Helpers, type: :proxy_pac
end
