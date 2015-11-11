require 'spec_helper'

RSpec.describe ProxyPacDumper, type: :aruba do
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

  let(:dumper) { ProxyPacDumper.new }
  let(:destination) { expand_path('proxy.pac') }

  describe '#dump' do
    before :each do
      allow(proxy_pac).to receive(:source).and_return(source)
    end

    context 'when proxy pac is string' do
      before :each do
        cd('.') do
          dumper.dump(proxy_pac, type: :string)
        end
      end

      it { expect(destination).to be_existing_file }
      it { expect(destination).to have_content proxy_pac.content }
    end

    context 'when proxy pac is file' do
      let(:source) { 'proxy.pac.in' }

      before :each do
        write_file(source, content)
      end

      before :each do
        cd('.') do
          dumper.dump(proxy_pac, type: :template)
        end
      end

      around :example do |example|
        cd('.') { example.call }
      end

      it { expect(destination).to be_existing_file }
      it { expect(destination).to have_content proxy_pac.content }
    end
  end
end
