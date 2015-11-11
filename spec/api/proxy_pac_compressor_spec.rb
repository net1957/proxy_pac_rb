require 'spec_helper'

RSpec.describe ProxyPacCompressor do
  subject(:proxy_pac) { instance_double('ProxyPac::ProxyPacFile') }

  let(:compressor) { described_class.new }
  let(:modified_content) { %(function FindProxyForURL(url, host) {\n    return \"DIRECT\";\n}) }

  let(:content) do
    <<-EOS.strip_heredoc.chomp
      // comment
      function FindProxyForURL(url, host) {
        return "DIRECT";
      }
    EOS
  end

  before :each do
    allow(proxy_pac).to receive(:content).and_return(content)
    allow(proxy_pac).to receive(:type?).with(:string).and_return(true)
  end

  before :each do
    expect(proxy_pac).to receive(:content=).with(modified_content)
  end

  describe '#modify' do
    context 'when string contains white paces' do
      it { compressor.compress(proxy_pac) }
    end
  end
end
