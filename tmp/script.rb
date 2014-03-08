#!/usr/bin/env ruby
require 'pry'

string = <<-EOS
function FindProxyForURL(url, host) {
  alert(MyIpAddress)
  if ( MyIpAddress == '127.0.0.2' ) {
    return "DIRECT";
  } else {
    return "PROXY localhost:8080";
  }
}
EOS

require 'proxy_pac_rb'


options = {}
client_ip = options.fetch(:client_ip, '127.0.0.1')
time      = options.fetch(:time, Time.now)

environment = ProxyPacRb::Environment.new(my_ip_address: client_ip, time: time)

file = ProxyPacRb::Parser.new(environment).source(string)
puts file.find('http://localhost')
puts file.find('http://localhost')

