module ProxyPacRb
  # Raised if proxy pac is invalid
  class LinterError < StandardError; end

  # raise on error
  class ProgramError < StandardError; end

  # raise on java script runtime error
  class RuntimeUnavailableError < StandardError; end

  # raise on invalid argument
  class InvalidArgumentError < StandardError; end

  # raise on invalid argument
  class UrlInvalidError < StandardError; end

  # raise if proxy pac could not be compiled
  class ParserError < StandardError; end

  # raise if proxy pac could not be compiled
  class ProxyPacInvalidError < StandardError; end
end
