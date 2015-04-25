require 'spec_helper'
require 'namedrb/rack/name_resolver'
require 'rack/lint'

RSpec.describe Namedrb::Rack::NameResolver, type: :rack_test do
  before(:each) { post '/', request: JSON.dump(resolve: input) }
  subject(:body) { last_response.body }

  let(:app) do
    a = Class.new(Sinatra::Base) do
      before do
        content_type 'application/dns'
      end

      post '/' do
      end
    end

    a.use Rack::Lint
    a.use Namedrb::Rack::NameResolver
    a.use Rack::Lint

    a.new
  end

  context 'when valid name is given' do
    let(:input) { 'google-public-dns-a.google.com' }
    let(:output) { '8.8.8.8' }

    it { expect(body).to include output }
  end

  context 'when valid ip is given' do
    let(:output) { 'google-public-dns-a.google.com' }
    let(:input) { '8.8.8.8' }

    it { expect(body).to include output }
  end
end
