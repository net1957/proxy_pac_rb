# encoding: utf-8

$LOAD_PATH << File.expand_path('../../lib', __FILE__)

# Set the rack environment to `test`
ENV["RACK_ENV"] = "test"

# Pull in all of the gems including those in the `test` group
require 'bundler'
Bundler.require :default, :test, :development

require 'local_pac/spec_helper'

Dir.glob(File.expand_path('../support/*.rb', __FILE__)).each { |f| require_relative f }

include LocalPac
