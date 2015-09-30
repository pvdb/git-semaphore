# Git::Semaphore

[![Build Status](https://semaphoreci.com/api/v1/projects/03b2dffc7112138851166c86adb456484426a712/7753/badge.png)](https://semaphoreci.com/pvdb/git-semaphore)

[![Travis CI](https://travis-ci.org/pvdb/git-semaphore.svg?branch=v0.0.6)](https://travis-ci.org/pvdb/git-semaphore)

git integration with [semaphoreci.com][] (via their API)

## Installation

Add this line to your application's Gemfile:

    gem 'git-semaphore'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install git-semaphore

## Authentication

Log into [semaphoreci.com][] and find your API `authentication token` in the `API` tab of one of your projects' `settings` page.

Next, choose one of the following mechanisms to make your API `authentication token` available to `Git::Semaphore`...

### via an environment variable

    $ export SEMAPHORE_AUTH_TOKEN="Yds3w6o26FLfJTnVK2y9"

### via `local` git config _(in a git working dir)_

    $ git config --local --replace-all semaphore.authtoken "Yds3w6o26FLfJTnVK2y9"

### via `global` git config

    $ git config --global --replace-all semaphore.authtoken "Yds3w6o26FLfJTnVK2y9"

## Usage

All of the below examples need to be run from within a git directory.

### listing of user's projects

    $ git semaphore --projects

### listing of project's branches

    $ git semaphore --branches

_(the project name is derived from the current git directory)_

### status of a project's branch

    $ git semaphore --status

_(the project and branch name are derived from the current git directory and the current git head)_

### formatting the raw `git semaphore` JSON output

After installing the quite brilliant [jazor gem][jazor] (`gem install jazor`), the `jazor` utility can be used to format the raw JSON output generated by the various `git semaphore` commands, as follows:

    $ git semaphore --projects | jazor -c
    $ git semaphore --branches | jazor -c
    $ git semaphore --status | jazor -c

## Development

    $ gem build git-semaphore.gemspec
    $ # this will generate a 'git-semaphore-x.y.z.gem' file
    $ gem install git-semaphore-x.y.z.gem

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

[semaphoreci.com]: https://semaphoreci.com/
[jazor]: https://github.com/mconigliaro/jazor
