# encoding: utf-8
module ProxyPacRb
  # Pac file
  class ProxyPacFile
    attr_accessor :valid, :type, :message, :readable
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
      valid == true
    end
  end
end
