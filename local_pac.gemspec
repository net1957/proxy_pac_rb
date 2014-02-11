# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'local_pac/version'

Gem::Specification.new do |spec|
  spec.name          = "local_pac"
  spec.version       = LocalPac::VERSION
  spec.authors       = ["Dennis Günnewig"]
  spec.email         = ["dg1@vrnetze.de"]
  spec.summary       = %q{Serve local proxy pac}
  spec.description   = %q{Serve local proxy pac}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'sinatra'

  #spec.add_development_dependency 'bundler', '~> 1.5'
  #spec.add_development_dependency 'rake'
end
