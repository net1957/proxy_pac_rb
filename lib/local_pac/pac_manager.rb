module LocalPac
  class PacManager
    def initialize(paths = default_paths, creator = PacFile)
      @paths   = Array(paths)
      @creator = creator
    end

    def find(name)
      default = proc { NullPacFile.new }
      pac_files.find(default) { |f| f.name == File.basename(name, '.pac').to_sym }
    end

    private

    def pac_files
      @paths.reduce([]) do |memo, path|
        memo.concat Dir.glob(File.join(path, '*.pac')).collect { |f| @creator.new(f) }
      end
    end

    def default_paths
      [
        File.expand_path(File.join(ENV['HOME'], '.config', 'pacfiles')),
        File.expand_path(File.join(ENV['HOME'], '.pacfiles')),
        File.expand_path('../../../files', __FILE__),
      ]
    end
  end
end
