Feature: How to Overcome Fear of Authority

  Scenario: run the main script with the token set in the env

    Given the "SEMAPHORE_AUTH_TOKEN" env variable is set
     When I run `git-semaphore --check-token`
     Then the exit status should be 0
      And the stderr should contain exactly:
        """
        """

  Scenario: run the main script with the token set in the env

    Given the "SEMAPHORE_AUTH_TOKEN" env variable is not set
     When I run `git-semaphore --check-token`
     Then the exit status should be 255
      And the stderr should contain exactly:
        """
        Please set (and export) the SEMAPHORE_AUTH_TOKEN env var...

        """
