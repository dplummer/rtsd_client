# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rtsd/version'

Gem::Specification.new do |spec|
  spec.name          = "rtsd"
  spec.version       = Rtsd::VERSION
  spec.authors       = ["Donald Plummer"]
  spec.email         = ["donald.plummer@gmail.com"]
  spec.description   = %q{A Ruby client for OpenTSDB, for writing metrics to the API.}
  spec.summary       = %q{A Ruby client for OpenTSDB.}
  spec.homepage      = "https://github.com/dplummer/rtsd_client"
  spec.license       = "MIT"
  spec.signing_key = "#{ENV['HOME']}/.gem/gem-private_key.pem"
  spec.cert_chain  = ["#{ENV['HOME']}/.gem/gem-public_cert.pem"]

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", ">= 1.1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "guard-bundler"
  spec.add_development_dependency "rb-inotify"
end
