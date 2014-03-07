# encoding: utf-8
require 'spec_helper'

describe ProxyPacRb do

  let(:sample_pac) do 
    create_file 'sample.pac', <<-EOS.strip_heredoc
      function FindProxyForURL(url, host) {
        return "DIRECT";
      }
    EOS
  end

  let(:example_1) do 
    create_file 'example_1.pac', <<-EOS.strip_heredoc
      // Taken from http://findproxyforurl.com/pac_file_examples.html
      function FindProxyForURL(url, host) {
      
        // If URL has no dots in host name, send traffic direct.
        if (isPlainHostName(host))
          return "DIRECT";
      
        // If specific URL needs to bypass proxy, send traffic direct.
        if (shExpMatch(url,"*domain.com*") ||
            shExpMatch(url,"*vpn.domain.com*"))
          return "DIRECT";
      
        // If IP address is internal or hostname resolves to internal IP, send direct.
        var resolved_ip = dnsResolve(host);
      
        if (isInNet(resolved_ip, "10.0.0.0", "255.0.0.0") ||
            isInNet(resolved_ip, "172.16.0.0",  "255.240.0.0") ||
            isInNet(resolved_ip, "192.168.0.0", "255.255.0.0") ||
            isInNet(resolved_ip, "127.0.0.0", "255.255.255.0"))
          return "DIRECT";
      
        // If not on a internal/LAN IP address, send traffic direct.
        if (!isInNet(myIpAddress(), "10.10.1.0", "255.255.255.0"))
          return "DIRECT";
      
        // All other traffic uses below proxies, in fail-over order.
        return "PROXY 1.2.3.4:8080; PROXY 4.5.6.7:8080; DIRECT";
      
      }
    EOS
  end

  let(:example_2) do 
    create_file 'example_2.pac', <<-EOS.strip_heredoc
      // Taken from http://findproxyforurl.com/pac_file_examples.html
      function FindProxyForURL(url, host) {
      
        // If IP address is internal or hostname resolves to internal IP, send direct.
        var resolved_ip = dnsResolve(host);
      
        if (isInNet(resolved_ip, "10.0.0.0", "255.0.0.0") ||
            isInNet(resolved_ip, "172.16.0.0",  "255.240.0.0") ||
            isInNet(resolved_ip, "192.168.0.0", "255.255.0.0") ||
            isInNet(resolved_ip, "127.0.0.0", "255.255.255.0"))
          return "DIRECT";
      
        // Use a different proxy for each protocol.
        if (shExpMatch(url, "http:*"))  return "PROXY proxy1.domain.com:3128";
        if (shExpMatch(url, "https:*")) return "PROXY proxy2.domain.com:3128";
        if (shExpMatch(url, "ftp:*")) return "PROXY proxy3.domain.com:3128";
      
      }
    EOS
  end

  let(:everything_but_local) do 
    create_file 'everything_but_local.pac', <<-EOS.strip_heredoc
      function FindProxyForURL(url, host) {
        if (isPlainHostName(host))
          return "DIRECT";
        else
          return "PROXY proxy:8080; DIRECT";
      }
    EOS
  end

  describe ".read" do
    it "should load a file from a path" do
      pac = ProxyPacRb.read(sample_pac)
      expect(pac).not_to be_nil
    end

    it "should return DIRECT for a url" do
      pac = ProxyPacRb.read(sample_pac)
      expect(pac.find('http://localhost')).to eq('DIRECT')
    end
  end

  describe ".source" do
    let(:source) do <<-JS.strip_heredoc
        function FindProxyForURL(url, host) {
          return "DIRECT";
        }
      JS
    end

    it "should load source" do
      pac = ProxyPacRb.source(source)
      expect(pac).not_to be_nil
    end

    it "should return DIRECT for a url" do
      pac = ProxyPacRb.source(source)
      expect(pac.find('http://localhost')).to eq('DIRECT')
    end
  end
end
