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

Given /^the "([A-Z_]+)" env variable is set$/ do |variable_name|
  # FIXME don't use the actual Ruby ENV, or at the very least
  # reset it to its original state afer each scenario/step/...
  ENV[variable_name] = 'blegga'
end

Given /^the "([A-Z_]+)" env variable is not set$/ do |variable_name|
  # FIXME don't use the actual Ruby ENV, or at the very least
  # reset it to its original state afer each scenario/step/...
  ENV.delete(variable_name)
end
