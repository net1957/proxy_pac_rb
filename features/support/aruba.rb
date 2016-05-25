# encoding: utf-8
# frozen_string_literal: true
require 'aruba/cucumber'

Aruba.configure do |config|
  config.working_directory = 'tmp/cucumber'
end
