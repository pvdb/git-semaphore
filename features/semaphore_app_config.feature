Feature: Configuration, Configuration, Configuration

  Scenario: create an app instance inside a git repo without config

    Given a git repo in directory "blegga"
      And the "SEMAPHORE_AUTH_TOKEN" env variable is not set
      And the "SEMAPHORE_PROJECT_TOKEN" env variable is not set
     Then the application doesn't have an auth token
      And the application doesn't have a project token

  Scenario: create an app instance inside a git repo with config

    Given a git repo in directory "blegga" with config:
        | semaphore.authtoken     | foo    |
        | semaphore.projecttoken  | bar    |
     Then the application uses "foo" as the auth token
      And the application uses "bar" as the project token

  Scenario: create an app instance inside a git repo without config

    Given a git repo in directory "blegga"
      And a runtime environment with config:
        | SEMAPHORE_AUTH_TOKEN    | foofoo |
        | SEMAPHORE_PROJECT_TOKEN | barbar |
     Then the application uses "foofoo" as the auth token
      And the application uses "barbar" as the project token

  Scenario: create an app instance inside a git repo with config

    Given a git repo in directory "blegga" with config:
        | semaphore.authtoken     | foo    |
        | semaphore.projecttoken  | bar    |
      And a runtime environment with config:
        | SEMAPHORE_AUTH_TOKEN    | foofoo |
        | SEMAPHORE_PROJECT_TOKEN | barbar |
     Then the application uses "foo" as the auth token
      And the application uses "bar" as the project token
