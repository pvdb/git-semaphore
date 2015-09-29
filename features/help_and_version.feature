Feature: Help Me I've Got Versionitis

  Scenario: get help for the main script

    When I get help for "git-semaphore"
    Then the exit status should be 0
     And the banner should be present
     And the banner should include the version
     And the banner should document that this app takes options
     And the following trollop options should be documented:
       | -v, --version               |
       | -h, --help                  |
       | -w, --working-dir           |
       | -p, --project-name          |
       | -b, --branch-name           |
       | -x, --check-auth            |
       | -y, --check-project         |
       | -z, --check-branch          |
       | -e, --env-config            |
       | -g, --git-config            |
       | -r, --projects              |
       | -a, --branches              |
       | -s, --status                |
       | -c, --commit-status         |
       | -u, --rebuild-last-revision |

  Scenario: get the version of the main script

    When I get the version of "git-semaphore"
    Then the exit status should be 0
     And the output should include the version
     And the output should include the app name
     And the output should include a copyright notice
