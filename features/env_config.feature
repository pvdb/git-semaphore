Feature: Configuration, Configuration, Configuration

  Scenario: run the main script with tokens set in the environment

    Given a runtime environment with config:
      | SEMAPHORE_AUTH_TOKEN    | foo|
      | SEMAPHORE_PROJECT_TOKEN | bar|
    When I run `git-semaphore --env-config`
    Then the exit status should be 0
     And the output should match /export SEMAPHORE_AUTH_TOKEN="foo"/
     And the output should match /export SEMAPHORE_PROJECT_TOKEN="bar"/
