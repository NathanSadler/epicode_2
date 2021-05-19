require('sinatra')
require('sinatra/reloader')
require('pry')
require('./lib/message')
require('./lib/board')
also_reload('lib/**/*.rb')

get('/') do
  @header = "Board Menu"
  @listable_name = "board"
  @listables = Board.all
  @creation_url = Board.get_creation_url
  erb(:list_menu)
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

# List a board's messages
get('/board/:board_id/messages') do
  board = Board.master_hash[params[:board_id].to_i]
  @header = board.name
  @listable_name = "message"
  @listables = Message.get_messages_in_board(board.id)
  @creation_url = Message.get_creation_url(board.id)
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
