# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capybara/async_runner/version'

Gem::Specification.new do |spec|
  spec.name          = "capybara-async_runner"
  spec.version       = Capybara::AsyncRunner::VERSION
  spec.authors       = ["Ilya Bylich"]
  spec.email         = ["ibylich@gmail.com"]

  spec.summary       = %q{Gem for running ascynrhonous jobs in Capybara.}
  spec.homepage      = "https://github.com/iliabylich/capybara-async-runner"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'rspec', '~> 3.2.0'
  spec.add_development_dependency 'rspec-its', '~> 1.2.0'
  spec.add_development_dependency 'capybara'
  spec.add_development_dependency 'poltergeist'
  spec.add_development_dependency 'pry'
end
