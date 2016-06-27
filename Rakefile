require "bundler/gem_tasks"
require "rake/testtask"

task :default => :test

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList['test/**/*_test.rb']
end

task :gemspec do
  @gemspec ||= eval(File.read(Dir["*.gemspec"].first))
end

desc "Validate the gemspec"
task :validate => :gemspec do
  @gemspec.validate
end
