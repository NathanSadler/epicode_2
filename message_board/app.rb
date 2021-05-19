require('sinatra')
require('sinatra/reloader')
require('pry')
require('./lib/message')
require('./lib/board')
also_reload('lib/**/*.rb')
enable :sessions

get('/') do
  @header = "Board Menu"
  @listable_name = "board"
  @listables = Board.all
  @creation_url = Board.get_creation_url
  @is_admin = session[:admin]
  erb(:list_menu)
end

# Enables or disables admin mode
get('/admin') do
  if (session[:admin] == false || session[:admin].nil?)
    session[:admin] = true
  else
    session[:admin] = false
  end

  redirect to('/')
end

# Form for creating board
get('/board/create') do
  @options = {
  :action => '/board/create',
  :method => 'post',
  :secret_method => nil,
  :default_name => ""
}
  erb(:board_form)
end

# Actually creates board
post('/board/create') do
  new_board = Board.new(params[:board_name])
  new_board.save
  redirect to('/')
end

# Form for editing a board
get('/board/:board_id/edit') do
  board = Board.master_hash[params[:board_id].to_i]
  @options = {
    :action => '/board/:board_id/edit',
    :method => 'post',
    :secret_method => 'patch',
    :default_name => board.name,
    :board_id => board.id
  }
  erb(:board_form)
end

# Actually updates a board
patch('/board/:board_id/edit') do
  board_to_update = Board.master_hash[params[:board_id].to_i]
  board_id = board_to_update.id
  board_to_update.name = params[:board_name]
  board_to_update.save
  redirect to("/board/#{board_id}/messages")
end

# Deletes a board
delete('/board/:board_id/delete') do
  board_to_delete = Board.master_hash[params[:board_id].to_i]
  board_to_delete.delete
  redirect to("/")
end

# List a board's messages
get('/board/:board_id/messages') do
  board = Board.master_hash[params[:board_id].to_i]
  @header = board.name
  @listable_name = "message"
  @listables = Message.get_messages_in_board(board.id)
  print(@listables)
  @creation_url = Message.get_creation_url(board.id)
  @board_id = board.id
  erb(:list_menu)
end

# Form for creating a Message
get("/board/:board_id/messages/create") do
  board_id = params[:board_id]
  @options = {
    :board_id => board_id,
    :action => "/board/#{board_id}/messages/create",
    :method => 'post',
    :default_title => "",
    :default_content => ""
  }
  erb(:message_form)
end

# Actually creates a message
post("/board/:board_id/messages/create") do
  foo = Message.new(params[:message_title], params[:board_id].to_i, params[:message_content])
  foo.save
  redirect to("board/#{params[:board_id]}/messages")
end

# Displays a message
get("/board/:board_id/messages/:message_id") do
  @is_admin = session[:admin]
  @message = Message.get_message_by_id(params[:message_id].to_i)
  erb :message_details
end

# Form for editing a message
get("/board/:board_id/messages/:message_id/edit") do
  board_id = params[:board_id].to_i
  message = Message.get_message_by_id(params[:message_id].to_i)
  message_id = message.id
  @options = {
    :board_id => board_id,
    :message_id => message_id,
    :action => "/board/#{board_id}/messages/#{message_id}/edit",
    :method => 'post',
    :secret_method => 'patch',
    :default_title => message.name,
    :default_content => message.content
  }
  erb(:message_form)
end

# Actually updates a message
patch("/board/:board_id/messages/:message_id/edit") do
  message_to_update = Message.get_message_by_id(params[:message_id].to_i)
  message_to_update.name = params[:message_title]
  message_to_update.content = params[:message_content]
  message_to_update.save
  redirect to("/board/#{message_to_update.board_id}/messages")
end
