When /^I run `([^`]*)` in "([^"]*)" directory$/ do |cmd, working_dir|
  step %(a directory named "#{working_dir}")
  cd working_dir ; in_current_dir do
    step %(I run `#{cmd}`)
  end
end

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

Given /^the "([A-Z_]+)" env variable is set(?: to "([^"]*)")?$/ do |variable_name, value|
  # FIXME don't use the actual Ruby ENV, or at the very least
  # reset it to its original state afer each scenario/step/...
  ENV[variable_name] = value || 'blegga'
end

Given /^the "([A-Z_]+)" env variable is not set$/ do |variable_name|
  # FIXME don't use the actual Ruby ENV, or at the very least
  # reset it to its original state afer each scenario/step/...
  ENV.delete(variable_name)
end

Given /^an app instance is created with the following config:$/ do |config_table|
  @app = Git::Semaphore::App.new(config_table.rows_hash)
end

Then /^the application uses "([^"]+)" as the auth token$/ do |auth_token|
  (@app || Git::Semaphore::App.new(ENV)).env_auth_token.should eq auth_token
end

Then /^the application uses "([^"]+)" as the project token$/ do |project_token|
  (@app || Git::Semaphore::App.new(ENV)).env_project_token.should eq project_token
end
