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
      Dollhouse.launch_from(Dir.pwd)
      Dollhouse.instances[params['server_name'].value].instance_eval params['cmd'].value
    end
  end

  mode 'destroy' do
    argument('server_name') { required }
    def run
      Dollhouse.launch_from(Dir.pwd)
      Dollhouse.instances[params['server_name'].value].destroy
    end
  end
end
