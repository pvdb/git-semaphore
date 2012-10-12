# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'git-semaphore/version'

Gem::Specification.new do |gem|
  gem.name          = "git-semaphore"
  gem.version       = Git::Semaphore::VERSION
  gem.authors       = ["Peter Vandenberk"]
  gem.email         = ["pvandenberk@mac.com"]
  gem.description   = ["git integration with https://semaphoreapp.com"]
  gem.summary       = ["git integration with https://semaphoreapp.com"]
  gem.homepage      = "https://github.com/pvdb/git-semaphore"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency('cucumber')
  gem.add_development_dependency('aruba')
  gem.add_development_dependency('methadone')
  gem.add_development_dependency('guard-cucumber')
  gem.add_development_dependency('rb-fsevent', ["~> 0.9.1"])
  gem.add_development_dependency('growl')
  gem.add_development_dependency('cucumber-pride')
end
