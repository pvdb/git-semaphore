Given /^I am an authenticated user on semaphoreapp\.com$/ do
  @auth_token = SEMAPHORE_TEST_TOKEN
end

Given /^get the list of all my projects via their API$/ do
  @response = Git::Semaphore::Api.get_response Git::Semaphore::Api.projects_uri(@auth_token)
end

def last_json
  @response.body
end
