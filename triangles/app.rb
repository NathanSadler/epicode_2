require('sinatra')
require('sinatra/reloader')
require('./lib/triangle')
also_reload('lib/**/*.rb')

get ('/') do
  "This should be the page with the form"
  erb(:triangle_form)
end

get('/triangle') do
  "This should be the page with the result"
  @triangle_type = Triangle.new(params[:side_a].to_f, params[:side_b].to_f,
  params[:side_c].to_f).get_type
  erb(:triangle_result)
end
