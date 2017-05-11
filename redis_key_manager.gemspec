# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "redis_key_manager/version"

Gem::Specification.new do |spec|
  spec.name          = "redis_key_manager"
  spec.version       = RedisKeyManager::VERSION
  spec.authors       = ["Matthew Harvey"]
  spec.email         = ["matthewh@oneflare.com"]

  spec.summary       = "Redis key manager"
  spec.description   = "Programmatically declare and enforce the Redis key patterns used by your project"
  spec.homepage      = "https://github.com/Oneflare/redis_key_manager"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rspec_junit_formatter", "~> 0.2"
  spec.add_development_dependency "simplecov", "~> 0.10.0"
end
