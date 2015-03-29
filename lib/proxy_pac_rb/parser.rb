# encoding: utf-8
module ProxyPacRb
  # Proxy Pac parser
  #
  # @example Usage
  #
  # parser = Parser.new
  # parser.load('http://example.com/proxy.pac')
  # parser.read('file.pac')
  #
  # string = ''
  # parser.source(string)
  class Parser
    private

    attr_reader :parser, :loader, :linter

    public

    def initialize(**args)
      @parser = ProxyPacParser.new(**args)
      @loader = ProxyPacLoader.new
      @linter = ProxyPacLinter.new
    end

    def parse(source)
      pac_file = ProxyPacFile.new source: source

      loader.load(pac_file)
      linter.lint(pac_file)

      unless pac_file.valid?
        $stderr.puts %(proxy.pac "#{pac_file.source}" is invalid.)

        return
      end

      parser.parse(pac_file)
    end

    def load(*args)
      $stderr.puts "Depreated: #load. Please use #parse instead."

      parse(*args)
    end

    def read(*args)
      $stderr.puts "Depreated: #read. Please use #parse instead."

     parse(*args)
    end

    def source(*args)
      $stderr.puts "Depreated: #source. Please use #parse instead."

      parse(*args)
    end
  end
end
