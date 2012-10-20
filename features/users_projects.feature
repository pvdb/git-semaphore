Feature: Show Me My Projects

  @vcr_api_projects
  Scenario: user's projects

    Given I am an authenticated user on semaphoreapp.com
      And get the list of all my projects via their API
     Then the JSON should be an array
