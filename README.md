# Git::Semaphore

[![Build Status](https://semaphoreci.com/api/v1/pvdb/git-semaphore/branches/master/badge.svg)](https://semaphoreci.com/pvdb/git-semaphore)

[![Travis CI](https://travis-ci.org/pvdb/git-semaphore.svg?branch=v0.0.6)](https://travis-ci.org/pvdb/git-semaphore)

Integrate git repositories with their corresponding project on [semaphoreci.com][] _(via the Semaphore API)_

## Features

* highly opiniated
* integrated with `git`
* caching of API results
* pagination of API calls
* enrichment of API data
* extensive API feature support
* support for multiple Semaphore accounts

## Semaphore API support

The following sections of the [Semaphore API][] are fully or partially supported by `git semaphore`:

| API section        |    | summary |
|--------------------|----|---------|
| [authentication][]      | ✅ | API authentication                    |
| [projects][]            | ✅ | listing projects                      |
| [branches and builds][] | ✅ | querying branches and managing builds |
| [servers and deploys][] | ❌ | querying servers and managing deploys |
| [webhooks][]            | ❌ | listing and managing webhooks         |

[authentication]:      https://semaphoreci.com/docs/api_authentication.html
[projects]:            https://semaphoreci.com/docs/projects-api.html
[branches and builds]: https://semaphoreci.com/docs/branches-and-builds-api.html
[servers and deploys]: https://semaphoreci.com/docs/servers-and-deploys-api.html
[webhooks]:            https://semaphoreci.com/docs/webhooks-api.html

The following [Semaphore API][] features are supported by `git semaphore`:

| API feature      |    | command |summary |
|------------------|----|---------|--------|
| [authentication][]    | ✅ |                               | provide user authentication via an authentication token            |
| [projects][]          | ✅ | `git semaphore --projects`    | list all projects and their current status                         |
| [project branches][]  | ✅ | `git semaphore --branches`    | list all branches for the current project                          |
| [branch status][]     | ✅ | `git semaphore --status`      | list the build status for the current branch                       |
| [branch history][]    | ✅ | `git semaphore --history`     | list the build history for the current branch                      |
| [build information][] | ✅ | `git semaphore --information` | detailed information for a given build number _(ie. all commits)_  |
| [build log][]         | ✅ | `git semaphore --log`         | execution logs for a given build number _(per thread and command)_ |
| [rebuild][]           | ✅ | `git semaphore --rebuild`     | rebuild last revision for the current branch                       |
| [launch build][]      | ❌ |                               | launch a build for the given commit SHA                            |
| [stop][]              | ❌ |                               | stop an in-progress build                                          |
| [deploy][]            | ❌ |                               | run a deploy from a given build                                    |

[project branches]:  https://semaphoreci.com/docs/branches-and-builds-api.html#project_branches
[branch status]:     https://semaphoreci.com/docs/branches-and-builds-api.html#branch_status
[branch history]:    https://semaphoreci.com/docs/branches-and-builds-api.html#branch_history
[build information]: https://semaphoreci.com/docs/branches-and-builds-api.html#build_information
[build log]:         https://semaphoreci.com/docs/branches-and-builds-api.html#build_log
[rebuild]:           https://semaphoreci.com/docs/branches-and-builds-api.html#rebuild
[launch build]:      https://semaphoreci.com/docs/branches-and-builds-api.html#launch_build
[stop]:              https://semaphoreci.com/docs/branches-and-builds-api.html#stop
[deploy]:            https://semaphoreci.com/docs/branches-and-builds-api.html#deploy

## Installation

Install the gem:

    gem install git-semaphore

And execute it as a `git` subcommand:

    git semaphore <options>

To get an overview of the available options, use:

    git-semaphore --help

## API authentication

Log into [semaphoreci.com][] and find **your authentication token** at the bottom of your [account settings][] page... this is also explained in [the Semaphore API documentation][authentication].

Next, choose one of the following mechanisms to make your API authentication token available to `git semaphore`...

### via *local* git config _(in a git working dir)_

    git config --local --replace-all semaphore.authtoken "Yds3w6o26FLfJTnVK2y9"

### via *global* git config

    git config --global --replace-all semaphore.authtoken "Yds3w6o26FLfJTnVK2y9"

### via an environment variable

    export SEMAPHORE_AUTH_TOKEN="Yds3w6o26FLfJTnVK2y9"

This is also the order in which tokens are searched for - and hence their precedence - meaning that if you have different Semaphore accounts for different projects _(e.g. work and personal projects)_ then you can configure your respective git repos with the authentication token of the corresponding Semaphore account.

## API result caching

For performance reasons _(especially for Semaphore API calls that are paginated)_, to enable offline use of the Semaphore API data, as well as to support interactive use of the data in e.g. `irb` or `pry` sessions, `git semaphore` transparently caches the results of all API calls in the `${HOME}/.git/semaphore/` directory.

This means that running `git semaphore` commands may return stale data, in cases where things have changed on `semaphoreci.com` since the last time `git semaphore` was run.

To delete the cache - and force a refresh of the Semaphore data on the next API call - use the `git semaphore --clean` command... this will empty out the entire `${HOME}/.git/semaphore` cache directory.

## Integration with `git`

When used inside a git repository, `git semaphore` uses [convention over configuration][coc] to figure out the relevant settings it needs in order to make valid Semaphore API requests:

| setting      | inside git repo    | pseudo-code                     | override                        |
|--------------|--------------------|---------------------------------|---------------------------------|
| owner & name | based on `${PWD}`  | `Dir.pwd.split('/').last(2)`    | `ENV['SEMAPHORE_PROJECT_NAME']` |
| branch name  | current git branch | `git symbolic-ref --short HEAD` | `ENV['SEMAPHORE_BRANCH_NAME']`  |
| commit SHA   | current git head   | `git rev-parse HEAD`            | `ENV['SEMAPHORE_COMMIT_SHA']`   |
| build number | last branch build  | `N/A`                           | `ENV['SEMAPHORE_BUILD_NUMBER']` |

However, each of these defaults can be overridden by setting the corresponding environment variable, as documented in the above table.  The same `ENV`-based override mechanism can be leveraged to use `git semaphore` outside of a git repository.

The `git semaphore --settings` command can be used to print out the values for these various settings:

    $ git semaphore --settings | jq '.'
    {
      "auth_token": "Yds3w6o26FLfJTnVK2y9",
      "project_name": "pvdb/git-semaphore",
      "branch_name": "master",
      "commit_sha": "4b59c3e41ca4592dfb01f77f2163154f3d3532fe",
      "build_number": "35"
    }
    $ _

The `git semaphore --internals` command adds the internal settings to the settings hash.

## Available commands

> ⚠️ all of the below examples need to be run from within a git repository ⚠️

### list the Semaphore settings

    git semaphore --settings

_(lists things like project name, branch name, commit SHA, etc.)_

### open the Semaphore page for the project's current branch

    git semaphore --browse

_(the project and branch names are derived from the current git repository and the current git head)_

### delete the local Semapore API cache

    git semaphore --clean

 _(this ensures the Semaphore data is refreshed for the subsequent API calls)_

### list all Semaphore projects

    git semaphore --projects

_(for the Semaphore user account corresponding to the authentication token)_

### list all of the project's branches

    git semaphore --branches

_(the project name is derived from the current git directory)_

### build status of the project's current branch

    git semaphore --status

_(the project and branch names are derived from the current git repository and the current git head)_

### build history of a project's branch

    git semaphore --history

_(the project and branch names are derived from the current git repository and the current git head)_

### commit information for the last build of a project's branch

    git semaphore --information

_(the project and branch names are derived from the current git repository and the current git head)_

### build command and logs for the last build of a project's branch

    git semaphore --log

## Formatting the raw `git semaphore` JSON output

After installing [the indispensable jq utility][jq] (`brew install jq`), the raw JSON output generated by the various `git semaphore` commands can be formatted and queried as follows:

    # pretty-print the git semaphore settings
    git semaphore --settings | jq '.'

    # pretty-print the git semaphore internals
    git semaphore --internals | jq '.'

    # list the full name of all Semaphore projects
    git semaphore --projects | jq -r '.[] | .full_name'

    # get the status of the last build for the current branch
    git semaphore --status | jq -r '.result'

    # list the build duration (in minutes) for all "passed" builds of the current branch
    git semaphore --history | jq -r '.builds | .[] | select(.result == "passed") | (.build_number|tostring) + "\t" + (.duration.minutes|tostring)'

    # list all commit SHAs that triggered the latest build
    git semaphore --information | jq -r '.commits | .[] | .id'

    # list the various thread commands for the latest build
    git semaphore --log | jq '.threads | .[] | .commands | .[] | .name'

[semaphoreci.com]:  https://semaphoreci.com/
[account settings]: https://semaphoreci.com/users/edit
[Semaphore API]:    https://semaphoreci.com/docs/api.html

[jq]:  https://stedolan.github.io/jq/
[coc]: https://en.wikipedia.org/wiki/Convention_over_configuration

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pvdb/git-semaphore. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

