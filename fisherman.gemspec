# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fisherman/version'

Gem::Specification.new do |spec|
  spec.name          = "fisherman"
  spec.version       = Fisherman::VERSION
  spec.authors       = ["Rusty Geldmacher"]
  spec.email         = ["russell.geldmacher@gmail.com"]

  spec.summary       = %q{API wrapper for Snapfish}
  spec.description   = %q{API wrapper for Snapfish's unpublished APIs}
  spec.homepage      = "https://github.com/rustygeldmacher/fisherman"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", "~> 0.11.0"
  spec.add_dependency "faraday_middleware", "~> 0.11.0"

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry-byebug"
end
