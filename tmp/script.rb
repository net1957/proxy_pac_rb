#!/usr/bin/env ruby
require 'pry'

require 'proxy_pac_rb'

string = <<-EOS
function FindProxyForURL(url, host) {
  if (weekdayRange("FRI", "SUN")) {
    return "PROXY localhost:8080";                                                                                                          
  } else {
    return "DIRECT";
  }
}
EOS

environment = ProxyPacRb::Environment.new(time: Time.parse('2014-03-06 12:00'))
file = ProxyPacRb::Parser.new(environment).source(string)
puts file.find('http://localhost')

environment = ProxyPacRb::Environment.new(time: Time.parse('2014-03-08 6:00'))
file = ProxyPacRb::Parser.new(environment).source(string)
puts file.find('http://localhost')
