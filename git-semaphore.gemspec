# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'git-semaphore/version'

Gem::Specification.new do |spec|
  spec.name          = "git-semaphore"
  spec.version       = Git::Semaphore::VERSION
  spec.authors       = ["Peter Vandenberk"]
  spec.email         = ["pvandenberk@mac.com"]
  spec.summary       = ["git integration with https://semaphoreci.com"]
  spec.description   = ["git integration with https://semaphoreci.com"]
  spec.homepage      = "https://github.com/pvdb/git-semaphore"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency('grit')
  spec.add_dependency('trollop')

  spec.add_development_dependency('pry')
  spec.add_development_dependency('rake')
  spec.add_development_dependency('bundler')
  spec.add_development_dependency('cucumber')
  spec.add_development_dependency('rspec')
  spec.add_development_dependency('aruba')
  spec.add_development_dependency('methadone')
  spec.add_development_dependency('vcr')
  spec.add_development_dependency('webmock')
  spec.add_development_dependency('jazor')
  spec.add_development_dependency('json_spec')
end
