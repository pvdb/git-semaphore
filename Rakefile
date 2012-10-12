require "bundler/gem_tasks"

require 'cucumber'
require 'cucumber/rake/task'

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features --format pretty"
end

# https://semaphoreapp.com/projects/854/edit
task :default => [:features]

# the principle of least surprise...
task :test => [:features]
task :cucumber => [:features]
