#!/usr/bin/env ruby

require 'rubygems'
require 'main'

Main do
  mode 'deploy' do
    argument('deployment') { required }

  end
end
