require('sinatra')
require('sinatra/reloader')
also_reload('lib/**/*.rb')

get('/') do
  "This will be our home page. '/' is always the root route in a Sinatra application."
end

get('/records') do
  "This route will show a list of all records."
end

get('/records/new') do
  "This will take us to a page with a form for adding a new record."
end

get('/records/:id') do
  "This route will show a specific record based on its ID. The value of ID here is #{params[:id]}."
end

post('/records') do
  "This route will add a record to our list of records.
end

get('/records/:id/edit') do
  "This will take us to a page with a form for updating a record with an ID of #{params[:id]}."
end

patch('/records/:id') do
  "This route will update a record.
end

delete('/records/:id') do
  "This route will delete a record. We can't reach it with a URL. In a future lesson, we will use a delete button that specifies a DELETE action to reach this route."
end
