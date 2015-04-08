# encoding: utf-8
$LOAD_PATH << File.expand_path('../../lib', __FILE__)

# Pull in all of the gems including those in the `test` group
require 'bundler'
Bundler.require :default, :test, :development, :debug

# Loading support files
Dir.glob(::File.expand_path('../support/**/*.rb', __FILE__)).each { |f| require_relative f }
