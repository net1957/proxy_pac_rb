# encoding: utf-8
require 'spec_helper'

describe File do
  let(:simple) do 
    <<-EOS.strip_heredoc
      function FindProxyForURL(url, host) {
        return "DIRECT";
      }
    EOS
  end

  let(:client_ip_pac) do 
    <<-EOS.strip_heredoc
      function FindProxyForURL(url, host) {
        if ( MyIpAddress() == '127.0.0.2' ) {
          return "DIRECT";
        } else {
          return "PROXY localhost:8080";
        }
      }
    EOS
  end

  let(:time_pac) do 
    <<-EOS.strip_heredoc
      function FindProxyForURL(url, host) {
        if ( timeRange(8, 18) ) {
          return "PROXY localhost:8080";
        } else {
          return "DIRECT";
        }
      }
    EOS
  end

  context '#find' do
    it 'should return DIRECT for a url' do
      file = ProxyPacRb::File.new(simple)
      expect(file.find('http://localhost')).to eq('DIRECT')
    end

    it 'respects client ip', :focus do
      file = ProxyPacRb::File.new(client_ip_pac)
      expect(file.find('http://localhost', client_ip: '127.0.0.1')).to eq('PROXY localhost:8080')
      expect(file.find('http://localhost', client_ip: '127.0.0.2')).to eq('DIRECT')
    end

    it 'respects time' do
      file = ProxyPacRb::File.new(time_pac)
      expect(file.find('http://localhost', time: '2014-03-07 12:00:00')).to eq('PROXY localhost:8080')
      expect(file.find('http://localhost', time: '2014-03-07 19:00:00')).to eq('DIRECT')
    end
  end
end
