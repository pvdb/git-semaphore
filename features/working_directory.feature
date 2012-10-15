Feature: It's Where You Can Find ME

  Scenario: get help for the main script

    When I run `git-semaphore -w` in "foo/bar" directory
    Then the exit status should be 0
     And the output should contain "foo/bar"
