# encoding: utf-8
# frozen_string_literal: true
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

    def initialize(*args)
      if args.first.is_a? Hash
        @parser = ProxyPacParser.new(**args.first)
      else
        $stderr.puts 'Deprecated: Use of positional parameters. Please use named parameters: environment: Environment.new.'
        @parser = ProxyPacParser.new(environment: args.first)
      end

      @loader = ProxyPacLoader.new
      @linter = ProxyPacLinter.new
    end

    def parse(source)
      pac_file = ProxyPacFile.new source: source

      loader.load(pac_file)
      linter.lint(pac_file)
      parser.parse(pac_file)

      pac_file
    end

    def load(*args)
      $stderr.puts 'Deprecated: #load. Please use #parse instead.'

      parse(*args)
    end

    def read(*args)
      $stderr.puts 'Deprecated: #read. Please use #parse instead.'

      parse(*args)
    end

    def source(*args)
      $stderr.puts 'Deprecated: #source. Please use #parse instead.'

      parse(*args)
    end
  end
end
