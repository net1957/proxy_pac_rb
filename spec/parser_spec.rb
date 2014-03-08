# encoding: utf-8
require 'spec_helper'

describe ProxyPacRb::Parser do
  let(:sample_pac) do 
    create_file 'sample.pac', <<-EOS.strip_heredoc
      function FindProxyForURL(url, host) {
        return "DIRECT";
      }
    EOS
  end

  context ".read" do
    it "should load a file from a path" do
      pac = ProxyPacRb::Parser.new.read(sample_pac)
      expect(pac).not_to be_nil
    end
  end

  context ".source" do
    let(:source) do <<-JS.strip_heredoc
        function FindProxyForURL(url, host) {
          return "DIRECT";
        }
      JS
    end

    it "should load source" do
      pac = ProxyPacRb::Parser.new.source(source)
      expect(pac).not_to be_nil
    end
  end

  context 'compile' do
    it 'supports a changeable ip address' do
      string = <<-EOS
      function FindProxyForURL(url, host) {
        if ( MyIpAddress() == '127.0.0.2' ) {
          return "DIRECT";
        } else {
          return "PROXY localhost:8080";
        }
      }
      EOS

      environment = ProxyPacRb::Environment.new(client_ip: '127.0.0.1')
      file = ProxyPacRb::Parser.new(environment).source(string)
      expect(file.find('http://localhost')).to eq('PROXY localhost:8080')

      environment = ProxyPacRb::Environment.new(client_ip: '127.0.0.2')
      file = ProxyPacRb::Parser.new(environment).source(string)
      expect(file.find('http://localhost')).to eq('DIRECT')
    end

    it 'supports a changeable date' do
      string = <<-EOS
      function FindProxyForURL(url, host) {
        if (weekdayRange("FRI", "SAT")) {
          return "PROXY localhost:8080";
        } else {
          return "DIRECT";
        }
      }
      EOS

      environment = Environment.new(time: Time.parse('2014-03-08 12:00'))
      file = ProxyPacRb::Parser.new(environment).source(string)
      expect(file.find('http://localhost')).to eq('PROXY localhost:8080')

      environment = Environment.new(time: Time.parse('2014-03-06 12:00'))
      file = ProxyPacRb::Parser.new(environment).source(string)
      expect(file.find('http://localhost')).to eq('DIRECT')
    end

    it 'supports time range' do
      string = <<-EOS
      function FindProxyForURL(url, host) {
        if (timeRange(8, 18)) {
          return "PROXY localhost:8080";                                                                                                          
        } else {
          return "DIRECT";
        }
      }
      EOS
      
      environment = ProxyPacRb::Environment.new(time: Time.parse('2014-03-06 12:00'))
      file = ProxyPacRb::Parser.new(environment).source(string)
      expect(file.find('http://localhost')).to eq('PROXY localhost:8080')
      
      environment = ProxyPacRb::Environment.new(time: Time.parse('2014-03-08 6:00'))
      file = ProxyPacRb::Parser.new(environment).source(string)
      expect(file.find('http://localhost')).to eq('DIRECT')
    end

    it 'supports a date range' do
      string = <<-EOS
      function FindProxyForURL(url, host) {
        if (dateRange("JUL", "SEP")) {
          return "PROXY localhost:8080";                                                                                                          
        } else {
          return "DIRECT";
        }
      }
      EOS
      
      environment = ProxyPacRb::Environment.new(time: Time.parse('2014-07-06 12:00'))
      file = ProxyPacRb::Parser.new(environment).source(string)
      expect(file.find('http://localhost')).to eq('PROXY localhost:8080')
      
      environment = ProxyPacRb::Environment.new(time: Time.parse('2014-03-08 6:00'))
      file = ProxyPacRb::Parser.new(environment).source(string)
      expect(file.find('http://localhost')).to eq('DIRECT')
    end

  end
end
