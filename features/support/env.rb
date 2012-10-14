$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', '..', 'lib')

require 'aruba/cucumber'
require 'methadone/cucumber'
require 'cucumber-pride'

require 'git-semaphore'
