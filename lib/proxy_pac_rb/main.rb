# encoding: utf-8
# Main
module ProxyPacRb
  @debug_mode = false

  class << self
    private

    attr_accessor :debug_mode

    public

    def debug_mode_enabled?
      debug_mode == true
    end

    def enable_debug_mode
      self.debug_mode = true
      %w(pry byebug).each { |l| require l }
    end

    def require_file_matching_pattern(pattern)
      Dir.glob(pattern).each { |f| require_relative f }
    end
  end
end
