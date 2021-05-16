require('sinatra')
require('sinatra/reloader')
require('./lib/artist')
require('./lib/stage')
require('pry')
also_reload('lib/**/*.rb')

# Homepage. Lists all stages and artists, and links to their detail page
get('/') do
  @stage_list = Stage.all_stages
  @artist_list = Artist.all_artists
  erb(:main_page)
end

# Stage info page. Lists artists on stage. Has links to pages for editing the
# stage, editing existing artists, and adding new artists
get('/stage/:id') do
  
end

# Page with form for creating a new stage
get('/create_stage') do
  erb(:create_stage)
end


# Handles creating a stage
post('/create_stage') do
  Stage.new(params[:stage_name])
  @stage_list = Stage.all_stages
  @artist_list = Artist.all_artists
  erb(:main_page)
end
