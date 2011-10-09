# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift(lib) unless $:.include?(lib)

require 'dollhouse/version'

Gem::Specification.new do |s|
  s.name        = "dollhouse"
  s.version     = Dollhouse::VERSION
  s.author      = "Glen Maddern"
  s.email       = "glen.maddern@gmail.com"
  s.summary     = "A place to manage your babushkas."
  s.description = "Dollhouse is a way to deploy servers. It is designed to be used with Babushka."
  s.homepage    = "http://github.com/geelen/dollhouse"

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "dollhouse"

  s.files        = Dir.glob('{bin,lib}/**/*') + %w(LICENSE README.md)
  s.executables  = %w(dollhouse)

  s.add_dependency 'main',       '~> 4.2.0'
  s.add_dependency 'fog',        '~> 0.2.30'
  s.add_dependency 'net-ssh',    '>= 2.0.23'
  s.add_dependency 'net-sftp',   '~> 2.0.4'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
end
