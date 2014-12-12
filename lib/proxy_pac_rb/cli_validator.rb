module ProxyPacRb
  # Validator for commandline options
  class CliValidator
    private

    attr_reader :options

    public

    def initialize(options)
      @options = options
    end

    def validate
      exit_with_message 'You need to provide at least one url. Multiple urls need to be separated by a space.' if empty_url?
      exit_with_message 'You need to provide a proxy pac file.' if empty_pac_file?
    end

    private

    def empty_url?
      options[:urls].blank?
    end

    def empty_pac_file?
      options[:proxy_pac].blank?
    end

    def exit_with_message(msg)
      $stderr.puts msg
      exit 1
    end
  end
end
