#!/usr/bin/env ruby

require 'bundler'
Bundler.require :default, :test, :development

require 'rack/directory'

run Rack::Directory.new(File.expand_path('../../tmp/cucumber', __FILE__))
