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

# All for handling items
get('/editor/item') do
  @object_name = "item"
  @object_name_plural = "items"
  @objects = Item.all_items
  erb(:menu_template)
end

get('/editor/item/create') do
  "dummy for item creation form"
end

# All for handling obstacles
get('/editor/obstacle') do
  @object_name = "obstacle"
  @object_name_plural = "obstacles"
  @objects = Obstacle.all_obstacles
  erb(:menu_template)
end

get('/editor/obstacle/create') do
  "dummy for obstacle creation form"
end

# All for handling paths
get('/editor/path') do
  @object_name = "path"
  @object_name_plural = "paths"
  @objects = Path.all_paths
  erb(:menu_template)
end

get('/editor/path/create') do
  @rooms = Room.all_rooms
  @obstacles = Obstacle.all_obstacles
  erb(:create_path)
end

post('/editor/path/create') do
  # Add stuff for handling situations when a user tries to add a path that would
  # go somewhere where there is already a path if you have the time
  print(params)
  selected_obstacle = params[:obstacle]
  if selected_obstacle == "None"
    selected_obstacle = nil
  end
  Path.new(params[:room_a].to_i, params[:room_a_direction].to_sym,
    params[:room_b].to_i, params[:room_b_direction].to_sym, selected_obstacle)
  redirect to('/editor/path')
end


# All for handling Rooms
get('/editor/room') do
  @object_name = "room"
  @object_name_plural = "rooms"
  @objects = Room.all_rooms
  erb(:menu_template)
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
