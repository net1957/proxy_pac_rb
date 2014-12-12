# encoding: utf-8
module ProxyPacRb
  module Cli
    # Find proxy for url
    class FindProxy < Thor::Group
      include Shared

      class_option :client_ip, default: '127.0.0.1', desc: 'Client IP-address', aliases: '-c'
      class_option :time, default: Time.now.to_s, desc: 'Time to use during lookup url', aliases: '-t'
      class_option :proxy_pac, desc: 'Proxy.pac-file', aliases: '-p', required: true
      class_option :urls, type: :array, desc: 'URLs to check against proxy pac', aliases: '-u', required: true

      def find_proxy
        CliValidator.new(options).validate

        client_ip = IPAddr.new(options[:client_ip])
        time      = Time.parse(options[:time])
        proxy_pac = read_proxy_pac(options[:proxy_pac])
        urls      = options[:urls]

        environment = ProxyPacRb::Environment.new(client_ip: client_ip, time: time)
        file        = ProxyPacRb::Parser.new(environment).source(proxy_pac)

        $stderr.printf("%30s: %-s\n", 'url', 'result')
        urls.each do |u|
          begin
            $stderr.printf("%30s: %-s\n", u, file.find(u))
          rescue Exceptions::UrlInvalid
            $stderr.puts "You provide an invalid url \"#{u}\". Please use a correct one."
          end
        end
      end
    end
  end
end
