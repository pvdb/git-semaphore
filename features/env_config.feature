Feature: Configuration, Configuration, Configuration

  Scenario: run the main script with tokens set in the environment

    Given the "SEMAPHORE_AUTH_TOKEN" env variable is set to "foo"
      And the "SEMAPHORE_PROJECT_TOKEN" env variable is set to "bar"
    When I run `git-semaphore --env-config`
    Then the exit status should be 0
     And the output should match /export SEMAPHORE_AUTH_TOKEN="foo"/
     And the output should match /export SEMAPHORE_PROJECT_TOKEN="bar"/

  Scenario: create an app instance with custom config

    Given an app instance is created with the following config:
      | SEMAPHORE_AUTH_TOKEN    | foo   |
      | SEMAPHORE_PROJECT_TOKEN | bar   |
     Then the application uses "foo" as the env auth token
      And the application uses "bar" as the env project token

  Scenario: run the main script with the auth token set in the env

    Given the "SEMAPHORE_AUTH_TOKEN" env variable is set to "foo"
     Then the application uses "foo" as the env auth token

  Scenario: run the main script with the project token set in the env

    Given the "SEMAPHORE_PROJECT_TOKEN" env variable is set to "bar"
     Then the application uses "bar" as the env project token
