# encoding: utf-8
require 'fedux_org/stdlib/environment'

module ProxyPacRb
  module SpecHelper
    module Environment
      include FeduxOrg::Stdlib::Environment
      alias_method :with_environment, :isolated_environment
    end
  end
end

# encoding: utf-8
RSpec.configure do |c|
  c.include ProxyPacRb::SpecHelper::Environment
end
