require "bundler/gem_tasks"

task :default => :cucumber

task :gemspec do
  @gemspec ||= eval(File.read(Dir["*.gemspec"].first))
end

desc "Validate the gemspec"
task :validate => :gemspec do
  @gemspec.validate
end

require 'cucumber'
require 'cucumber/rake/task'

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features --format pretty --tags ~@wip"
end
task :cucumber => :features
