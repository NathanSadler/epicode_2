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
  if Player.current_player.current_room != Room.end_room
    redirect to('/game')
  else
    erb(:win_screen)
  end
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
  @options = {
    :header_action => "Create",
    :action => "/editor/path/create",
    :room_id => nil
  }
  erb(:path_editor)
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

get('/editor/path/read/:id') do
  path = Path.get_path_by_id(params[:id].to_i)

  @attributes = {}
  @attributes.store("First Room", path.room_a.name) if path.room_a
  @attributes.store("Second Room", path.room_b.name) if path.room_b
  @attributes.store("First Room Direction", path.direction_a) if path.direction_a
  @attributes.store("Second Room Direction", path.direction_b) if path.direction_b
  @attributes.store("Obstacle", path.obstacle.name) if path.obstacle
  @name = path.name
  @back_link = '/editor/path'
  @edit_link = "/editor/path/update/#{path.id}"
  erb(:reader)
end


# All for handling room CRUD
get('/editor/room') do
  @object_name = "room"
  @object_name_plural = "rooms"
  @objects = Room.all_rooms
  erb(:menu_template)
end

get('/editor/room/create') do
  @options = {
    :header_action => "Create",
    :action => "/editor/room/create",
    :room_id => nil
  }
  erb(:room_editor)
end

post('/editor/room/create') do
  room_type = params[:room_type]
  new_room = Room.new(items={}, params[:room_name])
  # Set start and end rooms if needed
  if room_type == 'start'
    new_room.set_start_room
  end
  if room_type == 'end'
    new_room.set_end_room
  end
  # Override user's selections for start and end rooms if they haven't been
  # specified yet
  if Room.all_rooms.length == 0
    new_room.set_start_room
    new_room.set_end_room
  end

  # Add selected items to the room
  # use regex to get all
  item_keys = params.keys.select {|key| key.match?(/item_\d+\b/)}
  item_keys.each do |key|
    new_room.add_item(Item.get_item_by_id(key.match('\d\b').to_s.to_i))
  end
  redirect to("/editor/room")
end

# Details informaton about this room
get('/editor/room/read/:id') do
  @room = Room.get_room_by_id(params[:id].to_i)
  if (@room == Room.start_room)
    @special_status = "This room is the starting room"
  elsif (@room == Room.end_room)
    @special_status = "This room is the ending room"
  else
    @special_status = "This room is not the starting or ending room."
  end
  @items = @room.items
  erb(:read_room)
end

# View with form for editing a room
get('/editor/room/update/:id') do
  room_id = params[:id].to_i
  @options = {
    :header_action => "Edit",
    :action => "/editor/room/update/#{room_id}",
    :room_id => room_id,
    :secret_method => "patch"
  }
  erb(:room_editor)
end

# Actually updates the room
patch('/editor/room/update/:id') do
  # Gets needed info
  room_to_update = Room.get_room_by_id(params[:id].to_i)
  room_name = params[:room_name]
  room_type = params[:room_type]
  item_keys = params.keys.select {|key| key.match?(/item_\d+\b/)}

  # Changes room name
  room_to_update.set_name(room_name)

  # Sets room type (start, end, or neither)
  if room_type == 'start'
    room_to_update.set_start_room
  end
  if room_type == 'end'
    room_to_update.set_end_room
  end

  # Updates items in room
  room_to_update.clear_items
  item_keys.each do |key|
    room_to_update.add_item(Item.get_item_by_id(key.match('\d\b').to_s.to_i))
  end
  redirect to("/editor/room/read/#{room_to_update.id}")
end

# Deletes a room
delete('/editor/room/delete/:id') do
  room = Room.get_room_by_id(params[:id].to_i)
  room.delete
  redirect to('/editor/room')
end
