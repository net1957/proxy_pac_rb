# encoding: utf-8
require 'spec_helper'

RSpec.describe ProxyPacRb::Environment do
  let(:client_ip) { '127.0.0.1' }
  let(:time) { '1970-01-01 00:00:00' }
  let(:environment) { Environment.new(client_ip: client_ip, time: time) }

  describe '#initialize' do
    context 'when valid ip address is given' do
      it { expect { environment }.not_to raise_error }
    end

    context 'when invalid ip address is given' do
      let(:client_ip) { 'invalid_ip' }
      it { expect { environment }.to raise_error IPAddr::InvalidAddressError }
    end

    context 'when ip address is given as ip address-object' do
      let(:client_ip) { IPAddr.new('127.0.0.1') }
      it { expect { environment }.not_to raise_error }
    end

    context 'when valid time is given' do
      it { expect { environment }.not_to raise_error }
    end

    context 'when invalid time is given' do
      let(:time) { 'invalid_time' }
      it { expect { environment }.to raise_error ArgumentError }
    end

    context 'when time is given as time object' do
      let(:time) { Time.parse('1970-01-01 00:00:00') }
      it { expect { environment }.not_to raise_error }
    end
  end

  describe '#isResolvable()' do
    context 'when is "localhost"' do
      it { expect(environment.isResolvable('localhost')).to be true }
    end

    context 'when is "unexist.domain.localdomain"' do
      it { expect(environment.isResolvable('unexist.domain.localdomain')).to be false }
    end
  end

  describe '#isPlainHostName' do
    context 'when is url contains plain hostname "example"' do
      let(:result) { environment.isPlainHostName('example') }
      it { expect(result).to be true }
    end

    context 'when is url contains hostname with domain "example.com"' do
      let(:result) { environment.isPlainHostName('example.com') }
      it { expect(result).to be false }
    end
  end

  describe '#dnsDomainIs' do
    context 'when domain matches fqdn' do
      let(:result) { environment.dnsDomainIs('maps.example.com', '.example.com') }
      it { expect(result).to be true }
    end

    context 'when domain does not match fqdn' do
      let(:result) { environment.dnsDomainIs('maps.example.com', '.example.net') }
      it { expect(result).to be false }
    end
  end

  describe '#localHostOrDomainIs' do
    context 'when fqdn matches fqdn' do
      let(:result) { environment.localHostOrDomainIs('maps.example.com', 'maps.example.com') }
      it { expect(result).to be true }
    end

    context 'when plain host is included in fqdn' do
      let(:result) { environment.localHostOrDomainIs('maps', 'maps.example.com') }
      it { expect(result).to be true }
    end

    context 'when fqdn does not match fqdn' do
      let(:result) { environment.localHostOrDomainIs('maps.example.net', 'maps.example.com') }
      it { expect(result).to be false }
    end

    context 'when plain host is not included in fqdn' do
      let(:result) { environment.localHostOrDomainIs('text', 'maps.example.com') }
      it { expect(result).to be false }
    end
  end

  describe '#isInNet' do
    context 'when ip is included in network' do
      let(:result) { environment.isInNet('127.0.0.1', '127.0.0.0', '255.255.255.0') }
      it { expect(result).to be true }
    end

    context 'when ip is not included in network' do
      let(:result) { environment.isInNet('10.0.0.1', '127.0.0.0', '255.255.255.0') }
      it { expect(result).to be false }
    end

    context 'when a resolveable hostname is given' do
      let(:result) { environment.isInNet('www.example.net', '93.0.0.0', '255.0.0.0') }
      it { expect(result).to eq true }
    end

    context 'when a non-resolveable hostname is given' do
      let(:result) { environment.isInNet('www.example.net.localdomain', '93.0.0.0', '255.0.0.0') }
      it { expect(result).to eq false }
    end

    context 'when input is nil' do
      let(:result) { environment.isInNet(nil, '93.0.0.0', '255.0.0.0') }
      it { expect(result).to eq false }
    end

    context 'when input is empty string ""' do
      let(:result) { environment.isInNet('', '93.0.0.0', '255.0.0.0') }
      it { expect(result).to eq false }
    end
  end

  describe '#dnsResolve' do
    context 'when a resolveable hostname is given' do
      let(:result) { environment.dnsResolve('www.example.net') }
      it { expect(result).to eq '93.184.216.34' }
    end

    context 'when a resolveable hostname is given' do
      let(:result) { environment.dnsResolve('www.example.net.localdomain') }
      it { expect(result).to eq nil }
    end

    context 'when input is nil' do
      let(:result) { environment.dnsResolve(nil) }
      it { expect(result).to eq nil }
    end

    context 'when input is empty string ""' do
      let(:result) { environment.dnsResolve('') }
      it { expect(result).to eq nil }
    end

    context 'when input is gargabe' do
      let(:result) { environment.dnsResolve('§§jk:') }
      it { expect(result).to eq nil }
    end
  end

  describe '#dnsDomainLevels' do
    context 'when contains subdomains' do
      let(:result) { environment.dnsDomainLevels('maps.example.com') }
      it { expect(result).to eq 2 }
    end

    context 'when does not contain subdomains' do
      let(:result) { environment.dnsDomainLevels('maps') }
      it { expect(result).to eq 0 }
    end
  end

  describe '#shExpMatch' do
    context 'when pattern matches hostname' do
      let(:result) { environment.shExpMatch('maps.example.com', '*.com') }
      it { expect(result).to be true }
    end

    context 'when pattern does not match hostname' do
      let(:result) { environment.shExpMatch('maps.example.com', '*.de') }
      it { expect(result).to be false }
    end
  end

  describe '#alert' do
    context 'when message is given' do
      let(:result) do
        capture(:stderr) do
          environment.alert('message')
        end.chomp
      end

      it { expect(result).to eq 'message' }
    end
  end

  describe '#prepare' do
    context 'when valid' do
      let(:string) { '' }

      before(:each) { environment.prepare(string) }

      %w(
        myIpAddress
        weekdayRange
        dateRange
        timeRange
      ).each { |f| it { expect(string).to include(f) } }
    end
  end
end
