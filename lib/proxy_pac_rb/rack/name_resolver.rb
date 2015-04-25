require 'namedrb'
require 'rack'
require 'rack/request'

module Namedrb
  module Rack
    # Rack Middleware to resolve names
    #
    # @example Sinatra's <server>.rb
    # require 'namedrb/rack/name_resolver'
    # use Namedrb::Rack::NameResolver
    #
    # @example Rack's config.ru
    # require 'namedrb/rack/name_resolver'
    # use Namedrb::Rack::NameResolver
    #
    # @example Middleman's config.rb
    # require 'namedrb/rack/name_resolver'
    # use Namedrb::Rack::NameResolver
    #
    class NameResolver
      private

      attr_reader :resolver, :enabled

      public

      def initialize(
        app,
        enabled: true
      )
        @app        = app
        @resolver   = Namedrb::NameResolver.new
        @enabled    = enabled
      end

      def call(env)
        status, headers, body = @app.call(env)

        rack_request = ::Rack::Request.new(env)
        binding.pry

        return [status, headers, [body]] if enabled == false || !rack_request.post?

        objects = Array(JSON.parse(rack_request.params['request']).fetch('resolve', []))

        content = JSON.dump(
          result: Array(resolver.resolve(objects))
        )


        headers['Content-Type'] = 'application/json'
        headers['Content-Length'] = content.bytesize.to_s if headers['Content-Length']

        [status, headers, [content]]
      rescue => err
        $stderr.puts "An error occured: #{err.message}\n#{err.backtrace.join("\n")}"

        headers['Content-Type'] = 'text/plain'

        [500, headers, [err.message]]
      ensure
        body.close if body.respond_to? :close
      end
    end
  end
end
