require('sinatra')
require('sinatra/reloader')
require('pry')
require('./lib/hangmanword')
also_reload('lib/**/*.rb')

get('/') do
  HangmanWord.new
  redirect to ('/game')
end

get('/game') do
  @word = HangmanWord.current_word
  erb(:main)
end

post('/game') do
  current_word = HangmanWord.current_word
  #binding.pry
  current_word.guess_letter(params[:user_guess])
  redirect to('/game')
end
