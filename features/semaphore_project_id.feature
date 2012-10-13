Feature: Always Carry Identification Wherever You Go

  Scenario: run the main script with the project id set in the env

    Given the "SEMAPHORE_PROJECT_ID" env variable is set 
     When I run `git-semaphore --check-project id`
     Then the exit status should be 0
      And the stderr should contain exactly:
        """
        """
 
  Scenario: run the main script with the project id set in the env

    Given the "SEMAPHORE_PROJECT_ID" env variable is not set 
     When I run `git-semaphore --check-project`
     Then the exit status should be 255 
      And the stderr should contain exactly:
        """
        Please set (and export) the SEMAPHORE_PROJECT_ID env var...

        """
