# encoding: utf-8
RSpec.configure do |c|
  c.filter_run_including :focus => true
  c.run_all_when_everything_filtered                = true
  c.treat_symbols_as_metadata_keys_with_true_values = true
  c.before(:each) {
    ProxyPacRb.ui_logger.level = ::Logger::UNKNOWN
  }
end
