# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'statesman/trigger/version'

Gem::Specification.new do |spec|
  spec.name          = "statesman-trigger"
  spec.version       = Statesman::Trigger::VERSION
  spec.authors       = ["Alexa Grey"]
  spec.email         = ["devel@mouse.vc"]

  spec.summary       = %q{Create a database trigger that keeps the most recent Statesman state in sync.}
  spec.description   = %q{Create a database trigger that keeps the most recent Statesman state in sync.}
  spec.homepage      = "https://github.com/scryptmouse/statesman-trigger"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", ">= 3.2"
  spec.add_dependency "activerecord", ">= 3.2"
  spec.add_dependency "pg"
  spec.add_dependency "virtus", "~> 1.0"
  spec.add_dependency "dedent"

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-its"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "database_cleaner"
end
