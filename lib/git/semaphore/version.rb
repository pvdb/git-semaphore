module Git
  module Semaphore
    NAME = 'git-semaphore'.freeze
    VERSION = '3.1.0'.freeze

    def self.version
      "#{NAME} v#{VERSION}"
    end
  end
end
