require 'spec_helper'

RSpec.describe ProxyPacParser do
  subject(:proxy_pac) { instance_double('ProxyPac::ProxyPacFile') }

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

  before :each do
    allow(proxy_pac).to receive(:content).and_return(content)
    allow(proxy_pac).to receive(:valid?).and_return(true)
    allow(proxy_pac).to receive(:source).and_return(source)
    allow(proxy_pac).to receive(:type?).with(:string).and_return(true)
  end

  describe '#parse' do
    context 'when is valid' do
      before(:each) { expect(proxy_pac).to receive(:javascript=) }
      before(:each) { ProxyPacParser.new.parse(proxy_pac) }
    end

    context 'when is invalid' do
      before :each do
        allow(proxy_pac).to receive(:message).and_return('message')
      end

      let(:content) do
        <<-EOS.strip_heredoc.chomp
          function FindProxyForURL(url, host) {
           asdfasf $$ SDF
          }
        EOS
      end

      it { expect { ProxyPacParser.new.parse(proxy_pac) }.to raise_error ParserError }
    end
  end
end
