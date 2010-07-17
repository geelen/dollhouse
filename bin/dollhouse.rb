#!/usr/bin/env ruby

require 'rubygems'
require 'main'
require 'fileutils'

PROJECT_ROOT = File.dirname(__FILE__) + "/.."
Dir.glob(PROJECT_ROOT + '/app/*.rb').each { |f| require f }

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
