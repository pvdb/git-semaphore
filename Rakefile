# rubocop:disable Style/SymbolArray
# rubocop:disable Style/HashSyntax

require 'bundler/gem_tasks'

task :validate_gemspec do
  Bundler.load_gemspec('git-semaphore.gemspec').validate
end

task :version => :validate_gemspec do
  puts Git::Semaphore.version
end

require 'rubocop/rake_task'

RuboCop::RakeTask.new(:rubocop)

require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
end

task :default => [:version, :rubocop, :test]

task :documentation

task :ready => :documentation do
  sh('bundle --quiet') # regenerate Gemfile.lock e.g. if version has changed
  sh('git diff-index --quiet HEAD --') # https://stackoverflow.com/a/2659808
end

Rake::Task['build'].enhance([:default, :ready])

# rubocop:enable Style/HashSyntax
# rubocop:enable Style/SymbolArray
