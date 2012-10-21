Feature: Move Along, Nothing To See Here

  Scenario: run the main script in a directory that is not a git working dir

    When I run `git-semaphore`
    Then the exit status should be 255
     And the output should match /Error: "[^\042]*" is not a git working directory\.\.\. exiting!/

  Scenario: run the main script in a directory that is a git working dir

    When I run `git-semaphore` in a git working dir
    Then the exit status should be 1
     And the output should match /Coming soon! \(RuntimeError\)/
