# encoding: utf-8
lib = ::File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'proxy_pac_rb/version'

Gem::Specification.new do |spec|
  spec.name        = 'proxy_pac_rb'
  spec.version     = ProxyPacRb::VERSION
  spec.authors     = ['Dennis Günnewig']
  spec.email       = ['dg1@vrnetze.de']
  spec.homepage    = 'https://github.com/dg-vrnetze/proxy_pac_rb'
  spec.summary     = %q{gem to parse proxy auto-config files.}
  spec.description = <<-DESC
This gem uses a JavaScript runtime to evaulate a proxy auto-config file the same way a browser does to determine what proxy (if
any at all) should a program use to connect to a server. You must install on of the supported JavaScript runtimes:
therubyracer, therubyrhino, johnson or mustang.
DESC

  spec.homepage      = 'https://github.com/dg-vrnetze/ruby_pac_rb'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| ::File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'addressable'
end
