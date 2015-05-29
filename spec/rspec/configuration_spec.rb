require 'rspec_integration_spec_helper'

RSpec.describe ProxyPacRb::Rspec::Configuration do
  subject(:config) { described_class.new }

  it { expect(config).not_to be_nil }

  describe '#use_proxy' do
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

  describe 'option?' do
    let(:name) { :use_proxy }

    context 'when valid option' do
      it { expect(name).to be_valid_option }
    end

    context 'when invalid_option' do
      let(:name) { :blub }
      it { expect(name).not_to be_valid_option }
    end
  end
end
