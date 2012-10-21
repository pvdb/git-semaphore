Feature: It's Where You Can Find Me

  Scenario: print out the working directory

    Given a git repo in directory "foo/bar/qux_blegga"
     When I run `git-semaphore --working-dir` in "foo/bar/qux_blegga" directory
     Then the exit status should be 0
      And the output should contain "foo/bar"

  Scenario: print out the project name

    Given a git repo in directory "foo/bar/qux_blegga"
     When I run `git-semaphore --project-name` in "foo/bar/qux_blegga" directory
     Then the exit status should be 0
      And the output should contain "qux_blegga"

  Scenario: print out the branch name

    Given a git repo in directory "foo/bar/qux_blegga"
     When I run `git-semaphore --branch-name` in "foo/bar/qux_blegga" directory
     Then the exit status should be 0
      And the output should contain "master"
