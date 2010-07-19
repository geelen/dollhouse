require 'rubygems'
require "bundler"
Bundler.setup :default, :cucumber

PROJECT_ROOT = File.dirname(__FILE__) + '/../..'

require PROJECT_ROOT + '/lib/dollhouse.rb'
