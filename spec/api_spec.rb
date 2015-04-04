require 'spec_helper'

RSpec.describe ProxyPacRb do
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
    allow(proxy_pac).to receive(:valid).and_return(true)
    allow(proxy_pac).to receive(:source).and_return(source)
    allow(proxy_pac).to receive(:type?).with(:string).and_return(true)
  end

  describe ProxyPacCompressor do
    let(:compressor) { described_class.new }
    let(:modified_content) { %(function FindProxyForURL(){return"DIRECT"}) }

    before :each do
      expect(proxy_pac).to receive(:content=).with(modified_content)
    end

    describe '#modify' do
      context 'when string contains white paces' do
        it { compressor.compress(proxy_pac) }
      end
    end
  end

  describe ProxyPacDumper do
    let(:dumper) { ProxyPacDumper.new }
    let(:destination) { absolute_path('proxy.pac') }

    describe '#dump' do
      before :each do
        allow(proxy_pac).to receive(:source).and_return(source)
      end

      context 'when proxy pac is string' do
        before :each do
          in_current_dir do
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
          in_current_dir do
            dumper.dump(proxy_pac, type: :template)
          end
        end

        around :example do |example|
          in_current_dir { example.call }
        end

        it { expect(destination).to be_existing_file }
        it { expect(destination).to have_content proxy_pac.content }
      end
    end
  end

  describe ProxyPacLoader do
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

      context 'when proxy pac is nil', :focus do
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

  describe ProxyPacParser do
    describe '#parse' do
      let(:pac) { ProxyPacParser.new.parse(proxy_pac) }

      context 'when is valid' do
        it { expect(pac).to be_kind_of ProxyPac }
      end

      context 'when is valid' do
        let(:content) do
          <<-EOS.strip_heredoc.chomp
          function FindProxyForURL(url, host) {
           asdfasf $$ SDF
          }
          EOS
        end

        it { expect { pac }.to raise_error ParserError }
      end
    end
  end

  describe ProxyPacLinter do
    describe '#lint' do
      let(:linter) {  ProxyPacLinter.new(silent: true) }
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
          <<-EOS.strip_heredoc.chomp
          function FindProxyForURL(url, host) {
           asdfasf $$ SDF
          }
          EOS
        end

        it { linter.lint(proxy_pac) }
      end
    end
  end
end

RSpec.describe ProxyPacFile do
  subject(:proxy_pac) { ProxyPacFile.new source: source }

  let(:source) do
    <<-EOS.strip_heredoc.chomp
      function FindProxyForURL(url, host) {
        return "DIRECT";
      }
    EOS
  end

  describe '#valid?' do
    context 'when is invalid' do
      it { expect(proxy_pac).not_to be_valid }
    end

    context 'when is valid' do
      before(:each) { proxy_pac.valid = true }

      it { expect(proxy_pac).to be_valid }
    end
  end

  describe '#readable?' do
    context 'when is invalid' do
      it { expect(proxy_pac).not_to be_readable }
    end

    context 'when is valid' do
      before(:each) { proxy_pac.readable = true }

      it { expect(proxy_pac).to be_readable }
    end
  end
end
