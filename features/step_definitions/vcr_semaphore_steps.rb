Given /^I am an authenticated user on semaphoreapp\.com$/ do
  @auth_token = SEMAPHORE_TEST_TOKEN
  @project = '649e584dc507ca4b73e1374d3125ef0b567a949c'
  @branch = '89'
end

Given /^get the list of all my projects via their API$/ do
  @response = Git::Semaphore::Api.get_response Git::Semaphore::Api.projects_uri(@auth_token)
end

Given /^get the list of all the branches for one of my projects via their API$/ do
  @response = Git::Semaphore::Api.get_response Git::Semaphore::Api.branches_uri(@project, @auth_token)
end

Given /^get the build status of one of the branches for one of my projects via their API$/ do
  @response = Git::Semaphore::Api.get_response Git::Semaphore::Api.status_uri(@project, @branch, @auth_token)
end

Given /^request to rebuild the last revision of one of the branches for one of my projects via their API$/ do
  @response = Git::Semaphore::Api.get_response Git::Semaphore::Api.build_last_revision_uri(@project, @branch, @auth_token), :post
end

def last_json
  @response.body
end
