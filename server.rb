#!/usr/bin/env ruby

require "rubygems"
require "bundler/setup"
require 'sinatra'
require 'mongoid'
require 'rack-flash'
require 'bcrypt'

$: << File.dirname(__FILE__)
Dir['settings/**/*.rb'].each do |setting|
  require setting
end
Dir['models/**/*.rb'].each do |model|
  require model
end
Dir['controllers/**/*.rb'].each do |controller|
  require controller
end
Dir['helpers/**/*.rb'].each do |helper|
  require helper
end
Dir['hooks/**/*.rb'].sort.each do |hook|
  require hook
end

