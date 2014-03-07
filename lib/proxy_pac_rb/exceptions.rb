# encoding: utf-8
module ProxyPacRb
  module Exceptions
    #raise on error
    class ProgramError < StandardError; end

    #raise on java script runtime error
    class RuntimeUnavailable < StandardError; end
  end
end
