# encoding: utf-8
module ProxyPacRb
  # Dump Proxy pac to file system
  class ProxyPacDumper
    private

    attr_reader :type, :dumpers

    public

    def initialize
      @dumpers = {}
      @dumpers[:template] = ProxyPacTemplateDumper.new
    end

    def dump(proxy_pac, type:)
      dumpers[type].dump(proxy_pac)
    end
  end

  class ProxyPacTemplateDumper
    def dump(proxy_pac)
      ::File.write(output_path(proxy_pac.source), proxy_pac.content)
    end

    private

    def in_extension
      '.in'
    end

    def out_extension
      '.out'
    end

    def output_path(path)
      if ::File.exist?(path.gsub(/#{in_extension}*$/, '') + in_extension)
        return path.gsub(/#{in_extension}*$/, '')
      elsif ::File.exist? path
        return path + out_extension
      else
        fail Errno::ENOENT, "Both paths \"#{path.gsub(/#{in_extension}*$/, '') + in_extension}\" and \"#{path}\" do not exist."
      end
    end
  end
end
