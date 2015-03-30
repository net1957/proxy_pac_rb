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
      exit_with_message %(You need to provide a path to an existing proxy pac file. The file "#{options[:proxy_pac]}" does not exist.) if non_existing_proxy_pac_file?
    end

    private

    def proxy_pac_url?
      url = Addressable::URI.parse(options[:proxy_pac])
      return true if url.host

      false
    rescue StandardError
      false
    end

    def non_existing_proxy_pac_file?
      !proxy_pac_url? && !File.file?(options[:proxy_pac])
    end

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
