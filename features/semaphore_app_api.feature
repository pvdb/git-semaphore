Feature: Show Me What You've Got

  @vcr_api_projects
  Scenario: user's projects

    Given I am an authenticated user on semaphoreapp.com
      And get the list of all my projects via their API
     Then the JSON should be an array

  @vcr_api_branches
  Scenario: project's branches

    Given I am an authenticated user on semaphoreapp.com
      And get the list of all the branches for one of my projects via their API
     Then the JSON should be an array

  @vcr_api_status
  Scenario: branch status

    Given I am an authenticated user on semaphoreapp.com
      And get the build status of one of the branches for one of my projects via their API
     Then the JSON should be a hash
