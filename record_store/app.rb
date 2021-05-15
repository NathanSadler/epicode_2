require('sinatra')
require('sinatra/reloader')
require('./lib/album')
require('./lib/song')
require('pry')
also_reload('lib/**/*.rb')

get('/test') do
  @something = "This is a variable"
  erb(:whatever)
end

get('/') do
  @albums = Album.all
  @sold_albums = Album.sold_albums
  erb(:albums)
end

get('/albums') do
  @albums = Album.all
  @sold_albums = Album.sold_albums
  erb(:albums)
end

get('/albums/new') do
  #This will take us to a page with a form for adding a new album.
  erb(:new_album)
end

get('/albums/:id') do
  #This route will show a specific album based on its ID
  @album = Album.find(params[:id].to_i())
  erb(:album)
end

post('/albums') do
  name = params[:album_name]
  album = Album.new(name, nil)
  album.save()
  @albums = Album.all
  @sold_albums = Album.sold_albums
  erb(:albums)
end

get('/albums/:id/edit') do
  #This will take us to a page with a form for updating an album
  @album = Album.find(params[:id].to_i)
  erb(:edit_album)
end

patch('/albums/:id') do
  #This route will update an album.
  @album = Album.find(params[:id].to_i())
  @album.update(params[:name])
  @albums = Album.all
  @sold_albums = Album.sold_albums
  erb(:albums)
end

delete('/albums/:id') do
  #This route will delete a album.
  @album = Album.find(params[:id].to_i())
  @album.delete()
  @albums = Album.all
  @sold_albums = Album.sold_albums
  erb(:albums)
end

post('/buy_album') do
  album = Album.find(params[:album_id].to_i())
  album.sold
  @albums = Album.all
  @sold_albums = Album.sold_albums
  erb(:albums)
end

# Get the detail for a specific song such as lyrics and songwriters.
get('/albums/:id/songs/:song_id') do
  @song = Song.find(params[:song_id].to_i())
  erb(:song)
end

# Post a new song. After the song is added, Sinatra will route to the view for the album the song belongs to.
post('/albums/:id/songs') do
  @album = Album.find(params[:id].to_i())
  song = Song.new(params[:song_name], @album.id, nil)
  song.save()
  erb(:album)
end

# Edit a song and then route back to the album view.
patch('/albums/:id/songs/:song_id') do
  @album = Album.find(params[:id].to_i())
  song = Song.find(params[:song_id].to_i())
  song.update(params[:name], @album.id)
  erb(:album)
end

# Delete a song and then route back to the album view.
delete('/albums/:id/songs/:song_id') do
  song = Song.find(params[:song_id].to_i())
  song.delete
  @album = Album.find(params[:id].to_i())
  erb(:album)
end
