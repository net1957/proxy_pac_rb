# frozen_string_literal: true
require 'spec_helper'
require 'proxy_pac_rb/rspec'

RSpec.describe 'Parse proxy.pac', type: :proxy_pac do
  describe 'Browse url' do
    subject do
      <<-EOS.strip_heredoc.chomp
      function FindProxyForURL(url, host) {
        if (dnsDomainIs(host, 'localhost')) {
          return "DIRECT";
        } else {
          return "PROXY proxy.example.com:3128";
        }
      }
      EOS
    end

    context 'http://localhost' do
      let(:url) { 'http://localhost' }
      it { expect(url).to be_downloaded_via 'DIRECT' }
    end

    context 'http://www.example.org' do
      let(:url) { 'http://www.example.org' }
      it { expect(url).not_to be_downloaded_via 'DIRECT' }
    end
  end

  describe 'Change time' do
    subject do
      <<-EOS.strip_heredoc.chomp
      function FindProxyForURL(url, host) {
        if (weekdayRange("FRI", "SAT")) {
          return "PROXY localhost:8080";
        } else {
          return "DIRECT";
        }
      }
      EOS
    end

    let(:url) { 'http://www.example.org' }

    context 'when using default value Thursday, 1970-01-01' do
      it { expect(url).to be_downloaded_via 'DIRECT' }
    end

    context 'when time is Thursday, 1970-01-01' do
      let(:time) { '1970-01-01' }
      it { expect(url).to be_downloaded_via 'DIRECT' }
    end

    context 'when time is Friday, 1970-01-02' do
      let(:time) { '1970-01-02' }
      it { expect(url).to be_downloaded_via 'PROXY localhost:8080' }
    end
  end

  describe 'Change client ip' do
    subject do
      <<-EOS.strip_heredoc.chomp
      function FindProxyForURL(url, host) {
        if ( myIpAddress() == '127.0.0.2' ) {
          return "PROXY localhost:8080";
        } else {
          return "DIRECT";
        }
      }
      EOS
    end

    let(:url) { 'http://www.example.org' }

    context 'when using default value for ip, 127.0.0.1' do
      it { expect(url).to be_downloaded_via 'DIRECT' }
    end

    context 'when ip is 127.0.0.1' do
      let(:client_ip) { '127.0.0.1' }
      it { expect(url).to be_downloaded_via 'DIRECT' }
    end

    context 'when ip is 127.0.0.2' do
      let(:client_ip) { '127.0.0.2' }
      it { expect(url).to be_downloaded_via 'PROXY localhost:8080' }
    end
  end
end
