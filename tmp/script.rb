#!/usr/bin/env ruby
require 'pry'

string = <<-EOS
function FindProxyForURL(url, host) {
  alert(MyIpAddress())
  if ( MyIpAddress() == '127.0.0.2' ) {
    return "DIRECT";
  } else {
    return "PROXY localhost:8080";
  }
}
EOS

require 'proxy_pac_rb'


environment = ProxyPacRb::Environment.new(my_ip_address: '127.0.0.1', time: Time.now)
file = ProxyPacRb::Parser.new(environment).source(string)
puts file.find('http://localhost')

environment = ProxyPacRb::Environment.new(my_ip_address: '127.0.0.2', time: Time.now)
file = ProxyPacRb::Parser.new(environment).source(string)
puts file.find('http://localhost')

