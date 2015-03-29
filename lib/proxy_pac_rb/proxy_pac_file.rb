# encoding: utf-8
module ProxyPacRb
  # Pac file
  class ProxyPacFile
    attr_accessor :content, :valid
    attr_reader :source

    def initialize(source:)
      @source = source
      @valid  = false
    end

    def valid?
      valid == true
    end
  end
end
