# encoding: utf-8
require 'spec_helper'

describe ProxyPacRb::Parser do

  let(:sample_pac) do 
    create_file 'sample.pac', <<-EOS.strip_heredoc
      function FindProxyForURL(url, host) {
        return "DIRECT";
      }
    EOS
  end

  context ".read" do
    it "should load a file from a path" do
      pac = ProxyPacRb::Parser.read(sample_pac)
      expect(pac).not_to be_nil
    end
  end

  context ".source" do
    let(:source) do <<-JS.strip_heredoc
        function FindProxyForURL(url, host) {
          return "DIRECT";
        }
      JS
    end

    it "should load source" do
      pac = ProxyPacRb::Parser.source(source)
      expect(pac).not_to be_nil
    end
  end
end
