require('sinatra')
require('sinatra/reloader')
require('./lib/room')
require('./lib/obstacle')
require('pry')
also_reload('lib/**/*.rb')

get('/') do
  erb(:main_menu)
end
