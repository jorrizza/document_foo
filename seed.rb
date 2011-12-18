#!/usr/bin/env ruby

ACCOUNTANTS = 10
CUSTOMERS_EACH = 20

require "rubygems"
require "bundler/setup"
require 'mongoid'
require 'bcrypt'
require 'faker'

$: << File.dirname(__FILE__)
Dir['settings/**/*.rb'].each do |setting|
  require setting unless setting =~ /sinatra/
end
Dir['models/**/*.rb'].each do |model|
  require model
end

User.destroy_all
User.create(username: 'admin', password: 'administrator',
            password_confirmation: 'administrator', role: :admin)

ACCOUNTANTS.times do
  username = Faker::Company.name.downcase.gsub(/[ \,\.']/, '_')
  ac = User.create(username: username, password: 'accountant',
                   password_confirmation: 'accountant', role:
                   :accountant)
  CUSTOMERS_EACH.times do
    username = Faker::Name.name.downcase.gsub(/[ \,\.']/, '_')
    User.create(username: username, password: 'customer',
                password_confirmation: 'customer', role: :customer,
                accountant: ac)

  end
end

