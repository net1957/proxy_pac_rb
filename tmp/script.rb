#!/usr/bin/env ruby
require 'pry'

require 'proxy_pac_rb'

string = <<-EOS
function FindProxyForURL(url, host) {
  if ( myIpAddress() == '127.0.0.2' ) {
    return "DIRECT";
  } else {
    return "PROXY localhost:8080";
  }
}
EOS

environment = ProxyPacRb::Environment.new(client_ip: '127.0.0.1')
file = ProxyPacRb::Parser.new(environment).source(string)
puts(file.find('http://localhost'))

environment = ProxyPacRb::Environment.new(client_ip: '127.0.0.2')
file = ProxyPacRb::Parser.new(environment).source(string)
puts(file.find('http://localhost'))
