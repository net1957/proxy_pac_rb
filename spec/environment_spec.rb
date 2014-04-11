# encoding: utf-8
require 'spec_helper'

describe ProxyPacRb::Environment do
  let(:environment) do
    Environment.new(client_ip: '127.0.0.1', time: Time.now)
  end

  describe "#isResolvable()" do
    it "should return true for localhost" do
      expect(environment.isResolvable("localhost")).to be_true
    end

    it "should return false for unexist.domain.localdomain" do
      expect(environment.isResolvable('unexist.domain.localdomain')).to be_false
    end
  end

  describe '#isPlainHostName' do
    it 'returns true for google' do
      result = environment.isPlainHostName('google')
      expect(result).to be_true
    end

    it 'returns false for google.com' do
      result = environment.isPlainHostName('google.com')
      expect(result).to be_false
    end
  end

  describe '#dnsDomainIs' do
    it 'returns true for maps.google.com' do
      result = environment.dnsDomainIs('maps.google.com', '.google.com')
      expect(result).to be_true
    end

    it 'returns false for maps.ms.com' do
      result = environment.dnsDomainIs('maps.ms.com', '.google.com')
      expect(result).to be_false
    end
  end

  describe '#localHostOrDomainIs' do
    it 'returns true for maps.google.com' do
      result = environment.localHostOrDomainIs('maps.google.com', 'maps.google.com')
      expect(result).to be_true
    end

    it 'returns true for maps' do
      result = environment.localHostOrDomainIs('maps', 'maps.google.com')
      expect(result).to be_true
    end

    it 'returns false for maps.ms.com' do
      result = environment.dnsDomainIs('maps.ms.com', '.google.com')
      expect(result).to be_false
    end
  end

  describe '#isInNet' do
    it 'returns true for 127.0.0.1' do
      result = environment.isInNet('127.0.0.1', '127.0.0.0', '255.255.255.0')
      expect(result).to be_true
    end

    it 'returns false for 10.0.0.1' do
      result = environment.isInNet('10.0.0.1', '127.0.0.0', '255.255.255.0')
      expect(result).to be_false
    end
  end

  describe '#dnsResolve' do
    it 'returns the ip address for domain' do
      ip   = '8.8.8.8'
      name =  'google-public-dns-a.google.com'
      expect(environment.dnsResolve(name)).to eq(ip)
    end

    it 'return an empty string for a not resolvable host name' do
      name =  'not.resolvable.localhost.localdomain'
      expect(environment.dnsResolve(name)).to eq('')
    end
  end

  describe '#dnsDomainLevels' do
    it 'returns the count of domain levels (dots)' do
      result = environment.dnsDomainLevels('maps.google.com')
      expect(result).to eq(2)
    end
  end

  describe '#shExpMatch' do
    it 'returns true for maps.google.com' do
      result = environment.shExpMatch('maps.google.com', '*.com')
      expect(result).to be_true
    end

    it 'returns false for maps.ms.com' do
      result = environment.shExpMatch('maps.ms.com', '*.de')
      expect(result).to be_false
    end
  end

  describe '#alert' do
    it 'outputs msg' do
      result = capture(:stderr) do
        environment.alert('message')
      end

      expect(result.chomp).to eq('message')
    end
  end

  describe '#prepare' do
    it 'adds neccessary functions to source file' do
      string = ''
      environment.prepare(string)

      %w[
      myIpAddress
      weekdayRange
      dateRange
      timeRange
      ].each { |f| expect(string).to include(f) }
      
    end
  end
end
