require 'spec_helper'
require 'proxy_pac_rb/rspec'

RSpec.describe 'Compare to proxy.pac-files', type: :proxy_pac do
  subject do
    <<-EOS.strip_heredoc.chomp
      function FindProxyForURL(url, host) {
        return "DIRECT";
      }
    EOS
  end

  let(:file_a) do
    <<-EOS.strip_heredoc.chomp
      function FindProxyForURL(url, host) {
        return "DIRECT";
      }
    EOS
  end

  let(:file_b) do
    <<-EOS.strip_heredoc.chomp
      function FindProxyForURL(url, host) {
        return "DIRECT";
      }
    EOS
  end

  context 'when expected is a ProxyPacFile' do
    it { expect(proxy_pac).to be_the_same_proxy_pac_file file_b }
  end

  context 'when actual a ProxyPacFile and' do
    it { expect(file_b).to be_the_same_proxy_pac_file proxy_pac }
  end

  context 'when both are ProxyPacFile' do
    let(:already_proxy_pac) { ProxyPacFile.new(source: file_b) }

    before :each do
      loader = ProxyPacRb::ProxyPacLoader.new
      loader.load(already_proxy_pac)
    end

    it { expect(already_proxy_pac).to be_the_same_proxy_pac_file proxy_pac }
  end

  context 'when file "a" and file "b" are strings' do
    context 'when both are eqal' do
      it { expect(file_a).to be_the_same_proxy_pac_file file_b }
    end

    context 'when both are not eqal' do
      let(:file_a) do
        <<-EOS.strip_heredoc.chomp
        function FindProxyForURL(url, host) {
          return "DIRECT";
        }
        EOS
      end

      let(:file_b) do
        <<-EOS.strip_heredoc.chomp
        function FindProxyForURL(url, host) {
          return "PROXY localhost:8080";
        }
        EOS
      end

      it { expect(file_a).not_to be_the_same_proxy_pac_file file_b }
    end
  end
end
