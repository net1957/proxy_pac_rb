# encoding: utf-8
module LocalPac
  class PacFile
    attr_reader :path

    def initialize(path)
      @path = path
    end

    def name
      File.basename(@path, '.pac').to_sym
    end

    def content
      File.read(path)
    end

    def nil?
      false
    end
  end
end
