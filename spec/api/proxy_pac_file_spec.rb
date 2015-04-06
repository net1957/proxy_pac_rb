require 'spec_helper'

RSpec.describe ProxyPacFile do
  subject(:proxy_pac) { ProxyPacFile.new source: source }

  let(:source) do
    <<-EOS.strip_heredoc.chomp
      function FindProxyForURL(url, host) {
        return "DIRECT";
      }
    EOS
  end

  describe '#content' do
    let(:content) { 'content' }
    before(:each) { proxy_pac.content = content }

    context 'when is "content"' do
      it { expect(proxy_pac.content).to eq content }
    end

    context 'when is "content"' do
      let(:content) { nil }
      it { expect(proxy_pac.content).to eq '' }
    end
  end

  describe '#valid?' do
    context 'when is invalid' do
      it { expect(proxy_pac).not_to be_valid }
    end

    context 'when is valid' do
      before(:each) { proxy_pac.readable = true }
      before(:each) { proxy_pac.valid = true }

      it { expect(proxy_pac).to be_valid }
    end
  end

  describe '#readable?' do
    context 'when is invalid' do
      it { expect(proxy_pac).not_to be_readable }
    end

    context 'when is valid' do
      before(:each) { proxy_pac.readable = true }

      it { expect(proxy_pac).to be_readable }
    end
  end
end
