require 'spec_helper'
require 'proxy_pac_rb/rspec'

RSpec.describe 'Parse proxy.pac', type: :proxy_pac do
  subject do
    <<-EOS.strip_heredoc.chomp
      function FindProxyForURL(url, host) {
        if (dnsDomainIs(host, 'localhost') {
          return "DIRECT";
        } else {
          return "PROXY proxy.example.com:3128";
        }
      }
    EOS
  end

  describe 'Browse url' do
    context 'http://localhost' do
      let(:url) { 'http://localhost' }
      it { expect(url).to be_downloaded_via 'DIRECT' }
    end

    context 'http://www.example.org' do
      let(:url) { 'http://www.example.org' }
      it { expect(url).not_to be_downloaded_via 'DIRECT' }
    end
  end
end
