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
    it 'returns result of proxy.pac' do
      javascript = double('javascript')
      expect(javascript).to receive(:call).with("FindProxyForURL", "http://localhost", "localhost")

      ProxyPacRb::File.new(javascript).find("http://localhost")
    end
  end
end
