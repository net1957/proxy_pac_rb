# encoding: utf-8
require 'spec_helper'

RSpec.describe ProxyPacRb::Parser do
  subject(:proxy_pac) { Parser.new(environment: environment).parse(source) }

  let(:environment) { Environment.new }

  let(:content) do
    <<-EOS.strip_heredoc.chomp
      function FindProxyForURL(url, host) {
        return "DIRECT";
      }
    EOS
  end

  let(:source) do
    <<-EOS.strip_heredoc.chomp
      function FindProxyForURL(url, host) {
        return "DIRECT";
      }
    EOS
  end

  context 'when string is given' do
    it { expect(proxy_pac).not_to be_nil }
  end

  context 'when path is given' do
    let(:source) { absolute_path('proxy.pac') }
    before(:each) { write_file(source, content) }

    it { expect(proxy_pac).not_to be_nil }
  end

  context 'when ip address is given' do
    let(:source) do
      <<-EOS
      function FindProxyForURL(url, host) {
        if ( myIpAddress() == '127.0.0.2' ) {
          return "DIRECT";
        } else {
          return "PROXY localhost:8080";
        }
      }
      EOS
    end

    context 'when ip is 127.0.0.1' do
      let(:environment) { Environment.new(client_ip: '127.0.0.1') }
      it { expect(proxy_pac.find('http://localhost')).to eq('PROXY localhost:8080') }
    end

    context 'when ip is  127.0.0.2' do
      let(:environment) { Environment.new(client_ip: '127.0.0.2') }
      it { expect(proxy_pac.find('http://localhost')).to eq('DIRECT') }
    end
  end

  context 'when date is given' do
    let(:source) do
      <<-EOS
      function FindProxyForURL(url, host) {
        if (weekdayRange("FRI", "SAT")) {
          return "PROXY localhost:8080";
        } else {
          return "DIRECT";
        }
      }
      EOS
    end

    context 'when time is 2014-03-08 12:00' do
      let(:environment) { Environment.new(time: Time.parse('2014-03-08 12:00')) }
      it { expect(proxy_pac.find('http://localhost')).to eq('PROXY localhost:8080') }
    end

    context 'when time is 2014-03-06 12:0' do
      let(:environment) { Environment.new(time: Time.parse('2014-03-06 12:00')) }
      it { expect(proxy_pac.find('http://localhost')).to eq('DIRECT') }
    end
  end

  context 'when time range is used' do
    let(:source) do
      <<-EOS
      function FindProxyForURL(url, host) {
        if (timeRange(8, 18)) {
          return "PROXY localhost:8080";
        } else {
          return "DIRECT";
        }
      }
      EOS
    end

    context 'when time is 2014-03-06 12:00' do
      let(:environment) { ProxyPacRb::Environment.new(time: Time.parse('2014-03-06 12:00')) }
      it { expect(proxy_pac.find('http://localhost')).to eq('PROXY localhost:8080') }
    end

    context 'when time is 2014-03-08 6:00' do
      let(:environment) { ProxyPacRb::Environment.new(time: Time.parse('2014-03-08 6:00')) }
      it { expect(proxy_pac.find('http://localhost')).to eq('DIRECT') }
    end
  end

  context 'when date range is used' do
    let(:source) do
      <<-EOS
      function FindProxyForURL(url, host) {
        if (dateRange("JUL", "SEP")) {
          return "PROXY localhost:8080";
        } else {
          return "DIRECT";
        }
      }
      EOS
    end

    context 'when time is 2014-07-06 12:00' do
      let(:environment) { ProxyPacRb::Environment.new(time: Time.parse('2014-07-06 12:00')) }
      it { expect(proxy_pac.find('http://localhost')).to eq('PROXY localhost:8080') }
    end

    context 'when time is 2014-03-08 6:00' do
      let(:environment) { ProxyPacRb::Environment.new(time: Time.parse('2014-03-08 6:00')) }
      it { expect(proxy_pac.find('http://localhost')).to eq('DIRECT') }
    end
  end
end
