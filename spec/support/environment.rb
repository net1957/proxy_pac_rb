require 'fedux_org/stdlib/environment'

module LocalPac
  module SpecHelper
    module Environment
      include FeduxOrg::Stdlib::Environment
      alias_method :with_environment, :isolated_environment 
    end
  end
end

# encoding: utf-8
RSpec.configure do |c|
  c.include LocalPac::SpecHelper::Environment
end

