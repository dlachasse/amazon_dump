# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'amazon_dump/version'

Gem::Specification.new do |spec|
  spec.name          = "amazon_dump"
  spec.version       = AmazonDump::VERSION
  spec.authors       = ["David La Chasse"]
  spec.email         = ["david.lachasse@gmail.com"]
  spec.description   = %q{Dumps Amazon product data into local database from list of UPCs}
  spec.summary       = %q{Amazon product dump}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
