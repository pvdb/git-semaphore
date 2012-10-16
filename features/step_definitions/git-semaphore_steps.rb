#
# Steps that interact with ENV
#

Before do
 set_env('SEMAPHORE_AUTH_TOKEN', nil)
 set_env('SEMAPHORE_PROJECT_TOKEN', nil)
end

After do
  restore_env
end

Given /^the "([A-Z_]+)" env variable is set(?: to "([^"]*)")?$/ do |key, value|
  set_env(key, value || 'blegga')
end

Given /^the "([A-Z_]+)" env variable is not set$/ do |key|
  set_env(key, nil)
end

Given /^a runtime environment with config:$/ do |config_table|
  config_table.rows_hash.each do |key, value|
    set_env(key, value)
  end
end

#
# Steps that interact with git
#

Given /^a git repo in directory "([^"]*)"$/ do |project_name|
  @repo = Grit::Repo.init(File.join(current_dir, project_name))
end

Given /^a git repo in directory "([^"]*)" with config:$/ do |project_name, config_table|
  step %(a git repo in directory "#{project_name}")
  config_table.rows_hash.each do |key, value|
    @repo.config[key] = value
  end
end

Given /^"([^"]*)" git config is (not set|set) for git repo "([^"]*)"$/ do |key, is_or_isnt_set, project_name|
  step %(a git repo in directory "#{project_name}")
  @repo.config[key] = 'blegga' unless is_or_isnt_set == "not set"
end

#
# Steps that interact with Dir.pwd
#

When /^I run `([^`]*)` in "([^"]*)" directory$/ do |cmd, working_dir|
  step %(a directory named "#{working_dir}")
  cd working_dir
  step %(I run `#{cmd}`)
  @dirs = ['tmp', 'aruba'] # reset Aruba::API.current_dir
end

#
# Methodane/Aruba "extensions"/"customizations"
#

When /^I get the version of "([^"]*)"$/ do |app_name|
  @app_name = app_name
  step %(I run `#{app_name} --version`)
end

Then /^the output should include the version$/ do
  step %(the output should match /v\\d+\\.\\d+\\.\\d+/)
end

Then /^the output should include the app name$/ do
  step %(the output should match /#{Regexp.escape(@app_name)}/)
end

Then /^the output should include a copyright notice$/ do
  step %(the output should match /Copyright \\(c\\) [\\d]{4} [[\\w]+]+/)
end

#
# Steps that check config expectations
#

# Then /^the application uses "([^"]+)" as the git auth token$/ do |auth_token|
#   (@app || Git::Semaphore::App.new(@repo, ENV)).git_auth_token.should eq auth_token
# end

# Then /^the application uses "([^"]+)" as the git project token$/ do |project_token|
#   (@app || Git::Semaphore::App.new(@repo, ENV)).git_project_token.should eq project_token
# end

# Then /^the application uses "([^"]+)" as the env auth token$/ do |auth_token|
#   (@app || Git::Semaphore::App.new(@repo, ENV)).env_auth_token.should eq auth_token
# end

# Then /^the application uses "([^"]+)" as the env project token$/ do |project_token|
#   (@app || Git::Semaphore::App.new(@repo, ENV)).env_project_token.should eq project_token
# end

Then /^the application doesn't have an auth token$/ do
  (@app || Git::Semaphore::App.new(@repo, ENV)).auth_token.should be_nil
end

Then /^the application doesn't have a project token$/ do
  (@app || Git::Semaphore::App.new(@repo, ENV)).project_token.should be_nil
end

Then /^the application uses "([^"]+)" as the auth token$/ do |auth_token|
  (@app || Git::Semaphore::App.new(@repo, ENV)).auth_token.should eq auth_token
end

Then /^the application uses "([^"]+)" as the project token$/ do |project_token|
  (@app || Git::Semaphore::App.new(@repo, ENV)).project_token.should eq project_token
end
