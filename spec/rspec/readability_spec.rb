require 'spec_helper'
require 'proxy_pac_rb/rspec'

RSpec.describe 'Readability', type: :proxy_pac do
  let(:content) do
    <<-EOS.strip_heredoc.chomp
      function FindProxyForURL(url, host) {
        return "DIRECT";
      }
    EOS
  end

  context 'when is file' do
    let(:root_path) { current_dir }

    subject { 'proxy.pac' }

    context 'when proxy pac exist' do
      before :each do
        write_file 'proxy.pac', content
      end

      it { expect(proxy_pac).to be_readable }
    end

    context 'when proxy pac does not exist' do
      it { expect(proxy_pac).not_to be_readable }
    end
  end

  context 'when is url' do
    subject { 'http://www.example.com/proxy.pac' }

    context 'when is readable' do
      before(:each) { stub_request(:get, subject).to_return(body: content, status: 200) }
      it { expect(proxy_pac).to be_readable }
    end
    context 'when is not readable' do
      before(:each) { stub_request(:get, subject).to_raise(StandardError) }
      it { expect(proxy_pac).not_to be_readable }
    end
  end

  context 'when is string' do
    context 'it is always readable' do
      subject do
        <<-EOS.strip_heredoc.chomp
        function FindProxyForURL(url, host) {
          return "DIRECT";
        }
        EOS
      end

      it { expect(proxy_pac).to be_readable }
    end
  end
end
