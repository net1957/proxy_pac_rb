# encoding: utf-8
module ProxyPacRb
  module Cli
    # Find proxy for url
    class CompressProxyPac < Thor::Group
      include Shared

      class_option :proxy_pac, type: :array, desc: 'Proxy.pac-file(s)', aliases: '-p', required: true

      def find_proxy
        #proxy_pacs = options[:proxy_pac].map { |p| read_proxy_pac(p) }

        #proxy_pacs.each { |p| File.write(Uglifier.compile(File.read("source.js"))

        #environment = ProxyPacRb::Environment.new(client_ip: client_ip, time: time)
        #file        = ProxyPacRb::Parser.new(environment).source(proxy_pac)

        #$stderr.printf("%30s: %-s\n", 'url', 'result')
        #urls.each do |u|
        #  begin
        #    $stderr.printf("%30s: %-s\n", u, file.find(u))
        #  rescue Exceptions::UrlInvalid
        #    $stderr.puts "You provide an invalid url \"#{u}\". Please use a correct one."
        #  end
        #end
      end
    end
  end
end
