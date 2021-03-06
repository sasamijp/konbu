# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'konbu/version'

Gem::Specification.new do |spec|
  spec.name          = "konbu"
  spec.version       = Konbu::VERSION
  spec.authors       = ["sasamijp"]
  spec.email         = ["k.seiya28@gmail.com"]
  spec.description   = %q{Conversation AI}
  spec.summary       = %q{yeah}
  spec.homepage      = "http://sasami.asia/"
  spec.license       = "WTFPL"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_dependency "nokogiri"
  spec.add_dependency "extractcontent"
  spec.add_dependency "natto"
  spec.add_dependency "parallel"
  spec.add_dependency "sqlite3"
end
