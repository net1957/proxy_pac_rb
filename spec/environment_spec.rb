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

    it "should return false for awidhaowuhuiuhiuug" do
      expect(environment.isResolvable('asdfasdfasdfasdf')).to be_false
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
  end

  describe '#MyIpAddress ' do
    it 'returns the given ip address' do
      ip = '127.0.0.1'
      environment = Environment.new(client_ip: ip, time: Time.now)

      expect(environment.MyIpAddress).to eq(ip)
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

  describe '#weekdayRange' do
    let(:environment) { Environment.new(client_ip: '127.0.0.1', time: Time.parse('1991-08-25 12:00')) }

    it 'returns true for SUN - MON' do
      result = environment.weekdayRange("SUN", "MON")
      expect(result).to be_true
    end

    it 'returns false for FR' do
      result = environment.weekdayRange("FRI")
      expect(result).to be_false
    end

    it 'fails if wd1 or wd2 are not valid, e.g. German SO for Sunday' do
      expect {
        environment.weekdayRange("SO")
      }.to raise_error Exceptions::InvalidArgument
    end

  end

  describe '#dateRange' do
    let(:environment) { Environment.new(client_ip: '127.0.0.1', time: Time.parse('1991-08-25 12:00')) }

    it 'returns true for JUL - SEP' do
      result = environment.dateRange("JUL", "SEP")
      expect(result).to be_true
    end

    it 'returns false for MAR' do
      result = environment.dateRange("MAR")
      expect(result).to be_false
    end

    it 'fails if range is not valid' do
      expect {
        environment.dateRange("SEPT")
      }.to raise_error Exceptions::InvalidArgument
    end
  end

  describe '#timeRange' do
    let(:environment) { Environment.new(client_ip: '127.0.0.1', time: Time.parse('1991-08-25 12:00')) }

    it 'returns true for 8 - 18h' do
      result = environment.timeRange(8, 18)
      expect(result).to be_true
    end

    it 'returns false for MAR' do
      result = environment.timeRange(13,14)
      expect(result).to be_false
    end

    it 'fails if range is not valid' do
      expect {
        environment.timeRange("SEPT")
      }.to raise_error Exceptions::InvalidArgument
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
      MyIpAddress
      weekdayRange
      dateRange
      timeRange
      ].each { |f| expect(string).to include(f) }
      
    end
  end
end
