require('sinatra')
require('sinatra/reloader')
require('./lib/item')
require('./lib/obstacle')
require('./lib/path')
require('./lib/room')
require('./lib/player')
require('./lib/setup_default_maze')
require('pry')
also_reload('lib/**/*.rb')

get('/') do
  erb :main_menu
end

get('/editor') do
  erb :editor_menu
end

# For handling the actual game
# Game start menu
get('/game/menu') do
  erb :game_menu
end

# Sets up and starts game with default maze.
get('/game/startup/default') do
  setup_default_maze
  redirect to('/game')
end

# Displays the room the player is in
get('/game') do
  @player = Player.current_player
  @room = @player.current_room
  erb(:game)
end

# Tries moving the player along a given path from a starting point
get('/game/move/:starting_room_id/:path_id') do
  starting_room = Room.get_room_by_id(params[:starting_room_id].to_i)
  path = Path.get_path_by_id(params[:path_id].to_i)

  # If travel_from returns a block message, redirect to a page with the block
  # message
  next_room = path.travel_from(starting_room)
  if next_room.is_a?(String)
    redirect to("/game/obstacle_message/#{starting_room.id}/#{path.id}/false")
  end
  Player.current_player.move_to_room(next_room.id)
  redirect to('/game')
end

# Displays a message about a given path's obstacle and then moves the player to
# the appropriate room
get('/game/obstacle_message/:next_room_id/:path_id/:can_pass') do
  @path = Path.get_path_by_id(params[:path_id].to_i)
  @room = Room.get_room_by_id(params[:next_room_id].to_i)
  @can_pass = params[:can_pass]
  erb(:obstacle_message)
end

# Displays detailed information about the current room
get('/game/look_around/:room_id') do
  @room = Room.get_room_by_id(params[:room_id].to_i)
  erb(:look_around)
end

# Either interacts with or takes an item
get('/game/item_handler/:item_id') do
  @item = Item.get_item_by_id(params[:item_id].to_i)
  if(@item.is_a?(InteractableItem))
    @item.change_obstacle_states
  else
    Player.current_player.add_to_inventory(@item)
    Player.current_player.current_room.items.delete(@item.id)
  end
  redirect to('/game')
end

# All for handling item CRUD
get('/editor/item') do
  @object_name = "item"
  @object_name_plural = "items"
  @objects = Item.all_items
  erb(:menu_template)
end

get('/editor/item/create') do
  "dummy for item creation form"
end

# All for handling obstacle CRUD
get('/editor/obstacle') do
  @object_name = "obstacle"
  @object_name_plural = "obstacles"
  @objects = Obstacle.all_obstacles
  erb(:menu_template)
end

get('/editor/obstacle/create') do
  "dummy for obstacle creation form"
end

# All for handling path CRUD
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
  selected_obstacle = params[:obstacle]
  if selected_obstacle == "None"
    selected_obstacle = nil
  end
  Path.new(params[:room_a].to_i, params[:room_a_direction].to_sym,
    params[:room_b].to_i, params[:room_b_direction].to_sym, selected_obstacle)
  redirect to('/editor/path')
end


# All for handling room CRUD
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

# Temporary view for editing a room
post('/editor/room/:id') do
  "Test edit form for #{Room.get_room_by_id(params[:id])}"
end
