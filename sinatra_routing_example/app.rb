require('sinatra')
require('sinatra/reloader')
also_reload('lib/**/*.rb')

get('/') do
  "This will be our home page. '/' is always the root route in a Sinatra application."
end

get('/albums') do
  "This route will show a list of all albums."
end

get('/albums/new') do
  "This will take us to a page with a form for adding a new album."
end

get('/albums/:id') do
  "This route will show a specific album based on its ID. The value of ID here is #{params[:id]}."
end

post('/albums') do
  "This route will add an album to our list of albums. We can't access this by typing in the URL. In a future lesson, we will use a form that specifies a POST action to reach this route."
end

get('/albums/:id/edit') do
  "This will take us to a page with a form for updating an album with an ID of #{params[:id]}."
end

patch('/albums/:id') do
  "This route will update an album. We can't reach it with a URL. In a future lesson, we will use a form that specifies a PATCH action to reach this route."
end

delete('/albums/:id') do
  "This route will delete an album. We can't reach it with a URL. In a future lesson, we will use a delete button that specifies a DELETE action to reach this route."
end

get('/custom_route') do
  "We can even create custom routes, but we should only do this when needed."
end
