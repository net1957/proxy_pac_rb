require 'spec_helper'

RSpec.describe ProxyPacLoader do
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
    allow(proxy_pac).to receive(:source).and_return(source)
  end

  let(:loader) { ProxyPacLoader.new }
  let(:type) { :string }

  before :each do
    allow(proxy_pac).to receive(:source).and_return(source)
    allow(proxy_pac).to receive(:type=).with(type)
  end

  describe '#load' do
    context 'when proxy pac is string' do
      it_behaves_like 'a readable proxy.pac'
    end

    context 'when proxy pac is nil' do
      let(:source) { nil }
      let(:type) { :null }
      it_behaves_like 'an un-readable proxy.pac'
    end

    context 'when proxy pac is file' do
      let(:file) { 'proxy.pac' }
      let(:type) { :file }
      let(:source) { absolute_path(file) }

      before(:each) { allow(proxy_pac).to receive(:source).and_return(source) }

      context 'when is readable' do
        before(:each) { write_file(file, content) }

        it_behaves_like 'a readable proxy.pac'
      end

      context 'when is not readable' do
        it_behaves_like 'an un-readable proxy.pac'
      end
    end

    context 'when proxy pac is url' do
      let(:type) { :url }
      let(:source) { 'http://example.com/proxy.pac' }

      context 'when is readable' do
        before(:each) { stub_request(:get, source).to_return(body: content, status: 200) }

        it_behaves_like 'a readable proxy.pac'
      end

      context 'when is not readable' do
        before(:each) { stub_request(:get, source).to_raise(StandardError) }

        it_behaves_like 'an un-readable proxy.pac'
      end
    end
  end
end
