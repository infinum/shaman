# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'shaman/version'

Gem::Specification.new do |spec|
  spec.name          = 'shaman_cli'
  spec.version       = Shaman::VERSION
  spec.authors       = ['Rails team']
  spec.email         = ['team.rails@infinum.com']

  spec.summary       = 'Shaman CLI'
  spec.description   = 'CLI tool for deploying builds to Tryoutapps service'
  spec.homepage      = 'https://github.com/infinum/shaman'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_dependency 'commander'
  spec.add_dependency 'git'
  spec.add_dependency 'http'
  spec.add_dependency 'tty-prompt', '0.12.0'
  spec.add_dependency 'webmock'
  spec.metadata['rubygems_mfa_required'] = 'true'
end
