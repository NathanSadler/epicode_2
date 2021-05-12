require('sinatra')
require('sinatra/reloader')
also_reload('lib/**/*.rb')

get ('/') do
  "This should be the page with the form"
end

get('/triangle_:a_:b_:c') do
  "This should be the page with the result"
end
