# encoding: utf-8
module ProxyPacRb
  class ProxyPacTemplate
    private

    attr_reader :path, :compressed_content

    public

    attr_writer :compressed_content

    def initialize(path)
      @path = path
    end

    def write
      ::File.write(output_path, compressed_content)
    end

    def compress_me(compressor)
      compressor.compress(self)
    end

    def raw_content
      read_proxy_pac(input_path)
    end

    def input_path
      if ::File.exist?(path.gsub(/#{in_extension}*$/, '') + in_extension)
        return path.gsub(/#{in_extension}*$/, '') + in_extension
      elsif ::File.exist? path
        return path
      else
        fail Errno::ENOENT, "Both paths \"#{path.gsub(/#{in_extension}*$/, '') + in_extension}\" and \"#{path}\" do not exist."
      end
    end

    private

    def in_extension
      '.in'
    end

    def out_extension
      '.out'
    end

    def output_path
      if ::File.exist?(path.gsub(/#{in_extension}*$/, '') + in_extension)
        return path.gsub(/#{in_extension}*$/, '')
      elsif ::File.exist? path
        return path + out_extension
      else
        fail Errno::ENOENT, "Both paths \"#{path.gsub(/#{in_extension}*$/, '') + in_extension}\" and \"#{path}\" do not exist."
      end
    end

    def read_proxy_pac(path)
      uri = Addressable::URI.parse(path)

      uri.path = ::File.expand_path(uri.path) if uri.host.nil?

      ENV.delete 'HTTP_PROXY'
      ENV.delete 'HTTPS_PROXY'
      ENV.delete 'http_proxy'
      ENV.delete 'https_proxy'

      open(uri, proxy: false).read
    end
  end
end
