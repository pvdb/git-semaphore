# vim:syntax=ruby

$:.unshift Dir.pwd
$:.unshift File.join(Dir.pwd, 'lib')

require 'git-semaphore'

require 'rubygems'

require 'bundler'
Bundler.require

# That's all, Folks!
