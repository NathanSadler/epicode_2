require('sinatra')
require('sinatra/reloader')
require('./lib/album')
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
