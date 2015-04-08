module ProxyPacRb
  module Cli
    # Find proxy for url
    class InitProxyPac < Thor::Group
      include Shared
      include Thor::Actions

      class_option :proxy_pac, type: :string, desc: 'Proxy.pac-file', aliases: '-p', default: 'proxy.pac'
      class_option :test, enum: ['rspec'], desc: 'Test-framework - supported: rspec', aliases: '-t'

      def pre_init
        enable_debug_mode
      end

      def add_sources
        source_paths << File.expand_path('../../../../templates', __FILE__)
      end

      def create_proxy_pac
        template 'new_proxy_pac.pac.erb', options[:proxy_pac]
      end

      def create_test_framework_files
        directory 'test_framework/rspec', 'spec'
      end
    end
  end
end
