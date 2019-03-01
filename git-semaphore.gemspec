lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'git/semaphore/version'
require 'git/semaphore/gemspec'

Gem::Specification.new do |spec|
  spec.name          = Git::Semaphore::NAME
  spec.version       = Git::Semaphore::VERSION
  spec.authors       = ['Peter Vandenberk']
  spec.email         = ['pvandenberk@mac.com']

  spec.summary       = 'git integration with semaphoreci.com'
  spec.description   = 'command-line integration with semaphoreci.com for git repositories'
  spec.homepage      = 'https://github.com/pvdb/git-semaphore'
  spec.license       = 'MIT'

  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`
      .split("\x0")
      .reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.post_install_message = Git::Semaphore::PIM

  spec.add_dependency 'rugged', '~> 0.27'
  spec.add_dependency 'slop', '~> 4.6'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rubocop'
end
