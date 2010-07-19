#!/usr/bin/env ruby

require 'rubygems'
require "bundler"
Bundler.setup

require 'main'

require File.dirname(__FILE__) + '/../lib/dollhouse.rb'

Main do
  mode 'deploy' do
    argument('deployment') { required }
    argument('prefix') { optional }
    def run
      Dollhouse.launch_from(Dir.pwd)
      Dollhouse.initiate_deployment(params['deployment'].value.to_sym, :prefix => params['prefix'].value)
    end
  end

  mode 'exec' do
    argument('server_name') { required }
    argument('cmd') { required }
    def run

    end
  end
end
