# encoding: utf-8
module ProxyPacRb
  module Exceptions
    #raise on error
    class ProgramError < StandardError; end

    #raise on java script runtime error
    class RuntimeUnavailable < StandardError; end

    #raise on invalid argument
    class InvalidArgument < StandardError; end

    #raise on invalid argument
    class UrlInvalid < StandardError; end
  end
end
