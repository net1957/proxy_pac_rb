require 'spec_helper'
require 'proxy_pac_rb/rspec'

RSpec.describe 'Validity', type: :proxy_pac do
  subject do
    <<-EOS.strip_heredoc.chomp
      function FindProxyForURL(url, host) {
        return "DIRECT";
      }
    EOS
  end

  context 'when is valid' do
    it { expect(proxy_pac).to be_valid }
  end

  context 'when is not valid' do
    context 'when is not readable' do
      subject { 'function Gargabe' }

      it { expect(proxy_pac).not_to be_valid }
    end

    context 'when contains gargabe' do
      subject do
        <<-EOS.strip_heredoc.chomp
        function FindProxyForURL(url, host) {
          return $§"% "DIRECT";
        }
        EOS
      end

      it { expect(proxy_pac).not_to be_valid }
    end

    context 'when signature is wrong' do
      subject do
        <<-EOS.strip_heredoc.chomp
        function FindProxyForURL(url) {
          return "DIRECT";
        }
        EOS
      end

      it { expect(proxy_pac).not_to be_valid }
    end
  end
end
