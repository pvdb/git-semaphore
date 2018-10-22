require 'rugged'

module Git
  module Semaphore
    NAME = 'git-semaphore'.freeze
    VERSION = '2.1.0'.freeze

    DEPENDENCY_VERSIONS = [
      "rugged v#{Rugged::VERSION}",
      "#{RUBY_ENGINE} #{RUBY_VERSION}p#{RUBY_PATCHLEVEL}",
    ].join(', ').freeze

    LONG_VERSION = "#{NAME} v#{VERSION} (#{DEPENDENCY_VERSIONS})".freeze
  end
end
