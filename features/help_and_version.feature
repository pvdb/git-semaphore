Feature: Help Me I've Got Versionitis

  Scenario: get help for the main script

    When I get help for "git-semaphore"
    Then the exit status should be 0
     And the banner should be present
     And the banner should include the version
     And the banner should document that this app takes options
     And the following options should be documented:
       | --version, -v:       |
       | --help, -h:          |
       | --working-dir, -w:   |
       | --project-name, -p:  |
       | --branch-name, -b:   |
       | --check-auth, -x:    |
       | --check-project, -y: |
       | --check-branch, -z:  |
       | --env-config, -e:    |
       | --git-config, -g:    |
       | --projects, -r:      |
       | --branches, -a:      |
       | --status, -s:        |
       | --commit-status, -c: |

  Scenario: get the version of the main script

    When I get the version of "git-semaphore"
    Then the exit status should be 0
     And the output should include the version
     And the output should include the app name
     And the output should include a copyright notice
