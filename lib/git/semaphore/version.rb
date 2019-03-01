module Git
  module Semaphore
    NAME = 'git-semaphore'.freeze
    VERSION = '2.7.0'.freeze

    def self.version
      "#{NAME} v#{VERSION}"
    end
  end
end
