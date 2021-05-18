require('capybara/rspec')
require('./app')
require('room')
Capybara.app = Sinatra::Application
set(:show_exceptions, false)
