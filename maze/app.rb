require('sinatra')
require('sinatra/reloader')
require('./lib/item')
require('./lib/obstacle')
require('./lib/path')
require('./lib/room')
require('pry')
also_reload('lib/**/*.rb')

get('/') do
  erb :main_menu
end

get('/editor') do
  erb :editor_menu
end

get('/editor/room') do
  @rooms = Room.all_rooms
  erb(:rooms_menu)
end

get('/editor/room/create') do
  erb(:create_room)
end

post('/editor/room/create') do
  room_type = params[:room_type]
  foo = Room.new(items={}, params[:room_name])
  # Set start and end rooms if needed
  if room_type == 'start'
    foo.set_start_room
  end
  if room_type == 'end'
    foo.set_end_room
  end
  # Override user's selections for start and end rooms if they haven't been
  # specified yet
  if Room.all_rooms.length == 0
    foo.set_start_room
    foo.set_end_room
  end
  redirect to("/editor/room")
end

post('/editor/room/:id') do
  "Test edit form for #{Room.get_room_by_id(params[:id])}"
end
