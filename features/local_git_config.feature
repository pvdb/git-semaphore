Feature: Configuration, Configuration, Configuration

  Scenario: create a git repository with local config

    Given an initialized git repository for project "blegga"
      And the following settings have been stored in the local git config:
        | semaphore.authtoken    | foo   |
        | semaphore.projecttoken | bar   |
    When I run `git-semaphore --print-config` in "blegga" directory
    Then the exit status should be 0
     And the output should match /git config --local --replace-all semaphore.authtoken "foo"/
     And the output should match /git config --local --replace-all semaphore.projecttoken "bar"/

  @wip
  Scenario: run the main script with the auth token set in the git config

    Given an initialized git repository for project "blegga"
      And the following settings have been stored in the local git config:
        | semaphore.authtoken    | foo   |
        | semaphore.projecttoken | bar   |
     Then the application uses "foo" as the git auth token
      And the application uses "bar" as the git project token
