Feature: It's Where You Can Find Me

  Scenario: print out the working directory

    When I run `git-semaphore --working-dir` in "foo/bar" directory
    Then the exit status should be 0
     And the output should contain "foo/bar"
