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

      def pre_init
        enable_debug_mode
      end

      def find_proxy
        CliValidator.new(options).validate

        environment = ProxyPacRb::Environment.new(
          client_ip: IPAddr.new(options[:client_ip]),
          time: Time.parse(options[:time])
        )

        file = ProxyPacRb::Parser.new(environment: environment).parse(options[:proxy_pac])

        return if file.blank?

        $stderr.printf("%30s: %-s\n", 'url', 'result')
        options[:urls].each do |u|
          begin
            $stderr.printf("%30s: %-s\n", u, file.find(u))
          rescue UrlInvalidError
            $stderr.puts "You provide an invalid url \"#{u}\". Please use a correct one."
          rescue ProxyPacRb::ProxyPacInvalidError => err
            $stderr.puts err.message
          end
        end
      end
    end
  end
end
