# frozen_string_literal: true
require 'rack/test'

RSpec.configure do |config|
  config.include Rack::Test::Methods, type: :rack_test
end
