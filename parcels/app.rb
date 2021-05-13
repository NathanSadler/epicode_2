require('sinatra')
require('sinatra/reloader')
require('./lib/parcel')
also_reload('lib/**/*.rb')

get('/') do
  #Page with form for calculating package cost
  erb(:parcel_form)
end

post('/parcel') do
  # Page with result of calculating package cost
  #print(params)
  # length, width, height, weight
  @subject_parcel = Parcel.new(params[:package_length].to_f,
    params[:package_width].to_f, params[:package_height].to_f,
    params[:package_weight].to_f)
  @shipping_cost = @subject_parcel.cost_to_ship
  erb(:parcel_result)
end
