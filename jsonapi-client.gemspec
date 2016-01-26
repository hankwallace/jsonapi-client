# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jsonapi/client/version'

Gem::Specification.new do |spec|
  spec.name          = "jsonapi-client"
  spec.version       = JSONAPI::Client::VERSION
  spec.authors       = ["Hank Wallace"]
  spec.email         = ["hank@yesware.com"]

  spec.summary       = "Easily call a JSON API from Rails"
  spec.description   = "Easily call a JSON API from Rails"
  spec.homepage      = "https://github.com/hankwallace/jsonapi-client"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", ">= 3.2"
  spec.add_dependency "faraday", ">= 0.8.0"
  spec.add_dependency "faraday_middleware", "~> 0.9"
  spec.add_dependency "addressable", "~> 2.2"
  spec.add_dependency "activemodel", ">= 3.2"
  # spec.add_dependency "hashie"
  spec.add_dependency "json"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "json_spec"
end
