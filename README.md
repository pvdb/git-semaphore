# Git::Semaphore

git integration with https://semaphoreapp.com

## Installation

Add this line to your application's Gemfile:

    gem 'git-semaphore'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install git-semaphore

## Usage

All of the below examples need to be run from within a git directory.

### listing of user’s projects

    $ git semaphore --projects

### listing of project’s branches

    $ git semaphore --branches

_(the project name is derived from the current git directory)_

### status of a project’s branch

    $ git semaphore --status

_(the project and branch name are derived from the current git directory and the current git head)_

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
