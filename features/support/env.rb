$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', '..', 'lib')

require 'git-semaphore'

require 'aruba/cucumber'
require 'methadone/cucumber'
require 'cucumber-pride'
