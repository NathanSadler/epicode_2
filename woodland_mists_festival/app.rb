require('sinatra')
require('sinatra/reloader')
require('./lib/stage')
require('./lib/artist')
require('pry')
also_reload('lib/**/*.rb')

# Homepage. Lists all stages, and links to their detail page
get('/') do
  @stage_list = Stage.all_stages
  erb(:main_page)
end
