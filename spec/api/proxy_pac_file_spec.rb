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

  describe '#initalize' do
    context 'when source is ProxyPacFile' do
      before :each do
        proxy_pac.content    = source
        proxy_pac.javascript = BasicObject.new
        proxy_pac.message    = 'message'
        proxy_pac.parsable   = true
        proxy_pac.readable   = true
        proxy_pac.type       = :string
        proxy_pac.valid      = true
      end

      let(:proxy_pac_2) { ProxyPacFile.new(source: proxy_pac) }

      it { expect(proxy_pac.content).to eq proxy_pac_2.content }
      it { expect(proxy_pac.javascript).to eq proxy_pac_2.javascript }
      it { expect(proxy_pac.message).to eq proxy_pac_2.message }
      it { expect(proxy_pac.parsable).to eq proxy_pac_2.parsable }
      it { expect(proxy_pac.readable).to eq proxy_pac_2.readable }
      it { expect(proxy_pac.source).to eq proxy_pac_2.source }
      it { expect(proxy_pac.type).to eq proxy_pac_2.type }
      it { expect(proxy_pac.valid).to eq proxy_pac_2.valid }
    end
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


  describe '#content?' do
    let(:content) { 'content' }

    context 'when has content' do
      before(:each) { proxy_pac.content = content }
      it { expect(proxy_pac).to be_content }
    end

    context 'when does not have content' do
      it { expect(proxy_pac).not_to be_content }
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
