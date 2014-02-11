module LocalPac
  class Logger
    def initialize(path)
      FileUtils.mkdir_p File.dirname(path)
      @logger = ::Logger.new(path)
    end

    def write(*args, &block)
      @logger.<<(*args, &block)
    end

    private

    def default_path
    end
  end
end
