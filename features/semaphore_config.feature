Feature: Move Along, Nothing To See Here

  Scenario: run the main script

    Given the "SEMAPHORE_AUTH_TOKEN" env variable is set to "foo"
      And the "SEMAPHORE_PROJECT_TOKEN" env variable is set to "bar"
    When I run `git-semaphore --print-env`
    Then the exit status should be 0
     And the output should match /export SEMAPHORE_AUTH_TOKEN="foo"/
     And the output should match /export SEMAPHORE_PROJECT_TOKEN="bar"/
