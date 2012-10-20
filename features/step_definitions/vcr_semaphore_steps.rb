Given /^I am an authenticated user on semaphoreapp\.com$/ do
  @auth_token = SEMAPHORE_TEST_TOKEN
end

Given /^get the list of all my projects via their API$/ do
  # $ curl -i https://semaphoreapp.com/api/v1/projects?auth_token=Yds3w6o26FLfJTnVK2y9
  @response = Git::Semaphore::Api.get_response Git::Semaphore::Api.projects_uri(@auth_token)
end

Then /^the result is a valid JSON data structure$/ do
  require 'json'
  puts JSON.pretty_generate(JSON.parse(@response.body))
end