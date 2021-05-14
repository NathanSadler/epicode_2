require('sinatra')
require('sinatra/reloader')
require('./lib/riddle')
require('pry')
also_reload('lib/**/*.rb')

get('/') do
  Riddle.clear
  Riddle.new("What can you put in a bucket to make it lighter?", "A hole")
  Riddle.new("The faster you run, the harder it is to catch me. What am I?", "my breath")
  Riddle.new("The more of me you take, the more you leave behind. What am I?", "footsteps")
  @riddles = Riddle.all_riddles
  erb(:main_page)
end

post('/riddle') do
  @riddle_id = params[:riddle_id].to_i

  # Determines if the answer to the previous question was correct. If the user
  # came from the main page, it counts as given a correct answer even though the
  # user hasn't been given any riddles yet.
  if(@riddle_id == -1)
    is_answer_correct = true
  else
    is_answer_correct = Riddle.all_riddles[@riddle_id].right_answer?(params[:given_answer])
  end

  # If the user got the question right, takes them to the next question. If the
  # question the user answered was the last one and they answered correctly, takes
  # them to the success page. Otherwise, the user gets taken to the failure page
  if(is_answer_correct)
    if(@riddle_id == Riddle.all_riddles.length - 1)
      erb(:success)
    else
      @riddle_id += 1
      print(Riddle.all_riddles)
      erb(:riddle_page)
    end
  else
    erb(:fail)
  end
end
