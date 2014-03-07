require 'uri'
require 'ipaddr'
require 'resolv'
require 'time'

require 'proxy_pac_rb/version'
require 'proxy_pac_rb/exceptions'
require 'proxy_pac_rb/functions'
require 'proxy_pac_rb/file'
require 'proxy_pac_rb/runtimes/rubyracer'
require 'proxy_pac_rb/runtimes/rubyrhino'
require 'proxy_pac_rb/runtimes'

module ProxyPacRb
  class << self
    attr_reader :runtime

    def runtime=(runtime)
      fail Exceptions::RuntimeUnavailable, "#{runtime.name} is unavailable on this system" unless runtime.available?
      @runtime = runtime
    end

    def load(url, options = {})
      require "open-uri"
      File.new(open(url, { :proxy => false }.merge(options)).read)
    end

    def read(file)
      File.new(::File.read(file))
    end

    def source(source)
      File.new(source)
    end
  end

  self.runtime = Runtimes.autodetect
end
