require 'spec_helper'
require 'proxy_pac_rb/rspec'

RSpec.describe 'Parse proxy.pac', type: :proxy_pac do
  subject do
    <<-EOS.strip_heredoc.chomp
      function FindProxyForURL(url, host) {
        return "DIRECT";
      }
    EOS
  end

  describe 'Browse url' do
    context 'http://localhost' do
      let(:url) { 'http://localhost' }
      it { expect(url).to be_downloaded_via 'DIRECT' }
    end
  end
end
