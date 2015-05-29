require 'spec_helper'

RSpec.describe ProxyPacRb::CodeConfiguration do
  it_behaves_like 'a basic configuration'

  describe '#use_proxy' do
    subject(:config) { described_class.new }

    context 'when default is used' do
      it { expect(config.use_proxy).to be false }
    end

    context 'when modified' do
      context 'when valid value' do
        before(:each) { config.use_proxy = true }
        it { expect(config.use_proxy).to be true }
      end

      context 'when invalid value' do
        it { expect {  config.use_proxy = '' }.to raise_error ArgumentError }
      end
    end
  end
end
