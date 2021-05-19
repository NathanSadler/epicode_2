require('sinatra')
require('sinatra/reloader')
require('pry')
require('./lib/meter')
require('./lib/tamagotchi')
also_reload('lib/**/*.rb')

# redirects to tamagotchi creation page if there isn't one or the existing one
# is dead. Otherwise, redirects to main game
get('/') do
  @tamagotchi = Tamagotchi.current_tamagotchi
  if(@tamagotchi.nil? || !@tamagotchi.is_alive?)
    redirect to('/create_tamagotchi')
  else
    redirect to('/game')
  end
end

# Form for making new tamagotchi
get('/create_tamagotchi') do
  erb(:new_tamagotchi)
end

# Actually creates the new tamagotchi
post('/create_tamagotchi') do
  Tamagotchi.new(params[:name])
  redirect to('/game')
end

# Spends time and returns to game
get('/game/:action') do
  action = params[:action].to_sym
  Tamagotchi.current_tamagotchi.spend_time(action.to_sym)
  redirect to('/game')
end

get('/game') do
  @tamagotchi = Tamagotchi.current_tamagotchi
  erb(:game)
end
