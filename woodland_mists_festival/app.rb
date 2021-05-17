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
  @stage = Stage.get_stage_with_id(params[:id].to_i)
  erb(:stage_info)
end

# Page with form for creating a new stage
get('/create_stage') do
  erb(:create_stage)
end

# Handles creating a stage
post('/create_stage') do
  new_stage = Stage.new(params[:stage_name])
  redirect to("/stage/#{new_stage.id}")
end

# Page with form for editing a stage
get('/stage/:id/edit') do
  @stage = Stage.get_stage_with_id(params[:id].to_i)
  erb(:edit_stage)
end

# Handles actually editing the stage
patch('/stage/:id') do
  stage = Stage.get_stage_with_id(params[:id].to_i)
  stage.update(params[:stage_name])
  redirect to("/stage/#{stage.id}")
end

# Page with form for creating an artist
get('/artist/create') do
  @stage_list = Stage.all_stages
  erb(:create_artist)
end

# Handles actually creating the artist
post('/artist/create') do
  if (params[:stage_id] == -1)
    new_artist = Arist.new(params[:artist_name])
  else
    new_artist = Artist.new(params[:artist_name], params[:stage_id].to_i)
  end
  redirect to("/artist/#{new_artist.id}")
end

# Artist info page
get('/artist/:id') do
  @artist = Artist.get_artist_by_id(params[:id].to_i)
  erb(:artist_info)
end

# Page for editing artist
get('/artist/:id/edit') do
  @artist = Artist.get_artist_by_id(params[:id].to_i)
  @stage_list = Stage.all_stages
  erb(:edit_artist)
end

# Handles actually editing the stage
patch('/artist/:id/edit') do
  artist = Artist.get_artist_by_id(params[:id].to_i)
  artist.update_name(params[:artist_name])
  artist.update_stage(params[:stage_id].to_i)
  redirect to("/artist/#{artist.id}")
end

# Deletes an artist
delete('/artist/:id') do
  Artist.get_artist_by_id(params[:id].to_i).delete
  redirect to("/")
end

# Deletes a stage
delete('/stage/:id') do
  Stage.get_stage_with_id(params[:id].to_i).delete
  redirect to("/")
end
