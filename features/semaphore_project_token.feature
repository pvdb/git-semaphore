Feature: Always Carry Identification Wherever You Go

  Scenario: run the main script with the project token set in the env

    Given the "SEMAPHORE_PROJECT_TOKEN" env variable is set
     When I run `git-semaphore --check-project` in a git working dir
     Then the exit status should be 0
      And the stderr should contain exactly:
        """
        """

  Scenario: run the main script with the project token set in git config

    Given "semaphore.projecttoken" git config is set for git repo "blegga"
     When I run `git-semaphore --check-project` in "blegga" directory
     Then the exit status should be 0
      And the stderr should contain exactly:
        """
        """

  Scenario: run the main script with the project token not set in the env

    Given the "SEMAPHORE_PROJECT_TOKEN" env variable is not set
      And "semaphore.projecttoken" git config is not set for git repo "blegga"
     When I run `git-semaphore --check-project` in "blegga" directory
     Then the exit status should be 255
      And the stderr should contain exactly:
        """
        Please set - and export - the SEMAPHORE_PROJECT_TOKEN env variable
        Alternatively, set semaphore.projecttoken in your local git config

        """
