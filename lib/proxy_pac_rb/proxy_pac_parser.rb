# encoding: utf-8
# frozen_string_literal: true
module ProxyPacRb
  # Parse Proxy pac to file system
  class ProxyPacParser
    private

    attr_reader :environment, :runtime, :compiler

    public

    def initialize(
      environment: Environment.new,
      compiler: JavascriptCompiler.new
    )
      @environment = environment
      @compiler    = compiler
    end

    def parse(proxy_pac)
      return unless proxy_pac.valid?

      proxy_pac.javascript = compiler.compile(content: proxy_pac.content, environment: environment)
      proxy_pac.parsable = true
    rescue => err
      proxy_pac.parsable = false
      proxy_pac.message = err.message
    end
  end
end
