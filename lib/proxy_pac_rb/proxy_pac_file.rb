# encoding: utf-8
module ProxyPacRb
  # Pac file
  class ProxyPacFile
    include Comparable

    attr_accessor :valid, :type, :message, :readable, :javascript, :parsable, :source
    attr_writer :content

    def initialize(source:)
      if source.is_a? ProxyPacFile
        self.valid      = source.valid
        self.type       = source.type
        self.message    = source.message
        self.readable   = source.readable
        self.javascript = source.javascript
        self.parsable   = source.parsable
        self.content    = source.content
        self.source     = source.source
      else
        @source   = source
        @valid    = false
        @parsable = false
        @readable = false
      end
    end

    def content?
      !@content.nil?
    end

    def content
      return nil if @content.nil?

      @content.dup
    end

    def <=>(other)
      content <=> other.content
    end

    def type?(t)
      type == t
    end

    def readable?
      readable == true
    end

    def valid?
      valid == true
    end

    def parsable?
      parsable == true
    end

    def javascript?
      !javascript.nil?
    end

    def find(url, fail_safe: true)
      if fail_safe == true
        fail ProxyPacInvalidError, "The proxy.pac \"#{source}\" is not readable. Stopping here." unless readable?
        fail ProxyPacInvalidError, "The proxy.pac \"#{source}\" is not valid: #{message}. Stopping here." unless valid?
        fail ProxyPacInvalidError, "The proxy.pac \"#{source}\" is could not be parsed. There's no compiled javascript to use to lookup a url: #{message}. Stopping here." unless javascript?
      end

      uri = Addressable::URI.heuristic_parse(url)
      fail UrlInvalidError, 'url is missing host' unless uri.host

      javascript.FindProxyForURL(uri.to_s, uri.host)
    end
  end
end
