$LOAD_PATH << File.expand_path('../lib/', __FILE__)
require 'local_pac'

logger = LocalPac::Logger.new ENV['LOGFILE'] || File.expand_path(File.join(ENV['HOME'], '.local', 'share', 'local_pac', 'access.log'))
use Rack::CommonLogger, logger
run LocalPac::FileServer.new
