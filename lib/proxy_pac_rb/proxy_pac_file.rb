# encoding: utf-8
module ProxyPacRb
  # Pac file
  class ProxyPacFile
    attr_accessor :valid, :type, :message, :readable, :javascript
    attr_reader :source
    attr_writer :content

    def initialize(source:)
      @source = source
      @valid  = false
    end

    def content
      @content.to_s.dup
    end

    def type?(t)
      type == t
    end

    def readable?
      readable == true
    end

    def valid?
      valid == true && readable?
    end

    def javascript?
      !javascript.nil?
    end

    def find(url, fail_safe: true)
      if fail_safe == true
        fail ProxyPacInvalidError, "The proxy.pac \"#{source}\" is not readable. Stopping here." unless readable?
        fail ProxyPacInvalidError, "The proxy.pac \"#{source}\" is not valid: #{message}. Stopping here." unless valid?
        fail ProxyPacInvalidError, "The proxy.pac \"#{source}\" is could not be parsed: #{message}. Stopping here." unless javascript?
      end

      uri = Addressable::URI.heuristic_parse(url)
      fail UrlInvalidError, 'url is missing host' unless uri.host

      javascript.FindProxyForURL(uri.to_s, uri.host)
    end
  end
end
