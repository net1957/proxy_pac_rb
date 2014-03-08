#!/usr/bin/env ruby
require 'pry'

source = <<-EOS
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

file = ProxyPacRb::File.new(source)
puts file.find('http://localhost', client_ip: '127.0.0.2')
puts file.find('http://localhost', client_ip: '127.0.0.1')

