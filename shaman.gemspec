lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'shaman/version'

Gem::Specification.new do |spec|
  spec.name          = 'shaman_cli'
  spec.version       = Shaman::VERSION
  spec.authors       = ['Stjepan Hadjic']
  spec.email         = ['d4be4st@gmail.com']

  spec.summary       = 'Command tool for labs'
  spec.description   = 'Very cool command tool for infinum'
  spec.homepage      = 'http://www.infinum.co'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'pry-byebug'
  spec.add_dependency 'http'
  spec.add_dependency 'git'
  spec.add_dependency 'commander'
  spec.add_dependency 'tty-prompt', '0.12.0'
end
