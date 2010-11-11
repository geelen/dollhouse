PROJECT_ROOT = File.join(File.dirname(__FILE__), '..')
$:.unshift(File.dirname(__FILE__))
$:.unshift(File.join(PROJECT_ROOT, 'lib'))

require 'rubygems'
require 'bundler/setup'

require 'dollhouse'
require 'rspec'
