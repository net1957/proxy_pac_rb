# frozen_string_literal: true
require 'spec_helper'

RSpec.describe ProxyPacLinter do
  subject(:proxy_pac) { instance_double('ProxyPac::ProxyPacFile') }

  let(:content) do
    <<~EOS.chomp
      function FindProxyForURL(url, host) {
        return "DIRECT";
      }
    EOS
  end

  let(:source) do
    <<~EOS.chomp
      function FindProxyForURL(url, host) {
        return "DIRECT";
      }
    EOS
  end

  before :each do
    allow(proxy_pac).to receive(:source).and_return(source)
    allow(proxy_pac).to receive(:content).and_return(content)
    allow(proxy_pac).to receive(:valid).and_return(true)
    allow(proxy_pac).to receive(:type?).with(:string).and_return(true)
    allow(proxy_pac).to receive(:readable?).and_return(true)
  end

  describe '#lint' do
    let(:linter) { ProxyPacLinter.new(silent: true) }
    let(:result) { true }

    before(:each) do
      expect(proxy_pac).to receive(:valid=).with(result)
      allow(proxy_pac).to receive(:message=)
    end

    context 'when is valid' do
      it { linter.lint(proxy_pac) }
    end

    context 'when is proxy.pac does not contain FindProxyForURL' do
      let(:result) { false }
      let(:content) { '' }
      it { linter.lint(proxy_pac) }
    end

    context 'when is proxy.pac cannot be compiled' do
      let(:result) { false }
      let(:content) do
        <<~EOS.chomp
          function FindProxyForURL(url, host) {
           asdfasf $$ SDF
          }
        EOS
      end

      it { linter.lint(proxy_pac) }
    end
  end
end
