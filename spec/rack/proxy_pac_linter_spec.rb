# frozen_string_literal: true
require 'spec_helper'
require 'proxy_pac_rb/rack/proxy_pac_linter'
require 'rack/lint'

RSpec.describe ProxyPacRb::Rack::ProxyPacLinter, type: :rack_test do
  let(:content) do
    <<-EOS.strip_heredoc.chomp
    function FindProxyForURL(url, host) {
      return "DIRECT";
    }
    EOS
  end

  before(:each) { get '/' }
  subject(:body) { last_response.body }

  context 'when valid proxy pac is given' do
    let(:app) do
      a = Class.new(Sinatra::Base) do
        before do
          content_type 'application/x-ns-proxy-autoconfig'
        end

        get '/' do
          <<-EOS.strip_heredoc.chomp
          function FindProxyForURL(url, host) {
            return "DIRECT";
          }
          EOS
        end
      end

      a.use Rack::Lint
      a.use ProxyPacRb::Rack::ProxyPacLinter
      a.use Rack::Lint

      a.new
    end

    it { expect(body).to include content }
  end

  context 'when invalid proxy pac is given' do
    let(:content) { 'Unexpected string' }

    let(:app) do
      a = Class.new(Sinatra::Base) do
        before do
          content_type 'application/x-ns-proxy-autoconfig'
        end

        get '/' do
          <<-EOS.strip_heredoc.chomp
          function FindProxyForURL(url, host) {
            return $"§$ "DIRECT";
          }
          EOS
        end
      end

      a.use Rack::Lint
      a.use ProxyPacRb::Rack::ProxyPacLinter
      a.use Rack::Lint

      a.new
    end

    it { expect(body).to include content }
  end
end
