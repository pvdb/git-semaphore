Feature: Move Along, Nothing To See Here

  Scenario: run the main script

    When I run `git-semaphore`
    Then the exit status should be 1
     And the output should match /Coming soon! \(RuntimeError\)/
