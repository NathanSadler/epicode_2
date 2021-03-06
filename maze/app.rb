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

# Sets up and starts the current maze.
get('/game/startup/current') do
  # Creates the player
  player = Player.new(Room.start_room.id)
  # Reset environmental obstacles to their default states
  OtherObstacle.set_all_to_default

  # Restore the items of each room
  Room.all_rooms.each do |room|
    room.restore_items
    room.update
  end
  # Begin game
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

# Resets maze to default
get('/editor/reset') do
  setup_default_maze
  redirect to('/editor')
end

# All for handling item CRUD
get('/editor/item') do
  @object_name = "item"
  @object_name_plural = "items"
  @objects = Item.all_items
  erb(:menu_template)
end

# Lets user select between creating a collectible item and a interactable one
get('/editor/item/create') do
  @object_name = "Item"
  @types = {
    "Collectible Item" => '/editor/item/create/collectible',
    "Interactable Item" => '/editor/item/create/interactable'
  }
  erb(:object_type_selector)
end

# Form for creating collectible item
get('/editor/item/create/collectible') do
  @options = {
    :header_action => "Create",
    :object_name => "item",
    :action => "/editor/item/create"
  }

  @fields = {
    :item_name => {
      :field_type => "text",
      :name_and_id => "item_name",
      :label_text => "Item Name"
      }
  }
  erb(:generic_editor)
end

# Form for creating an interactable item
get('/editor/item/create/interactable') do
  @options = {
    :header_action => "Create",
    :object_name => "item",
    :action => "/editor/item/create"
  }

  @fields = {
    :item_name => {
      :field_type => "text",
      :name_and_id => "item_name",
      :label_text => "Item Name"},
    :interaction_text => {
      :field_type => "text",
      :name_and_id => "interaction_text",
      :label_text => "Interaction Text"
    },
    :linked_obstacles => {
      :field_type => "checkboxes",
      :section_header => "Linked Obstacles",
      :name_id_prefix => "obstacle",
      :checkable_options => OtherObstacle.all_obstacles
      }
  }
  erb(:generic_editor)
end

post('/editor/item/create') do
  # Determines if this should be an interactable item or a normal one, then saves
  # it appropriately
  if (params.keys.select {|foo| foo.match?(/obstacle_\d+\b/)}).length > 0
    linked_obstacles = []
    params.keys.each do |key|
      if key.match?(/obstacle_\d+\b/)
        linked_obstacles.push(Obstacle.get_obstacle_by_id(key.match('\d\b').to_s.to_i))
      end
    end
    new_item = InteractableItem.new(params[:item_name], linked_obstacles)
    new_item.set_interaction_text(params[:interaction_text])
  else
    new_item = Item.new(params[:item_name])
  end
  redirect to("/editor/item/read/#{new_item.id}")
end


get('/editor/item/read/:id') do
  item = Item.get_item_by_id(params[:id].to_i)
  @name = item.name
  @back_link = "/editor/item"
  @attributes = {}
  if (item.is_a?(InteractableItem))
    @edit_link = "/editor/item/update/#{item.id}/interactable"
    linked_obstacles = item.linked_obstacles.map {|foo| foo.name}
    linked_obstacles_str = linked_obstacles.join(", ")
    @attributes["Interaction Text"] = item.interaction_text
  else
    @edit_link = "/editor/item/update/#{item.id}/collectible"
    linked_obstacles = Obstacle.all_obstacles.select {|foo| foo.is_a?(ItemObstacle)}
    linked_obstacles = linked_obstacles.select {|foo| foo.can_pass?([item])}
    linked_obstacles = linked_obstacles.map {|foo| foo.name}
    linked_obstacles_str = linked_obstacles.join(", ")
  end

  if linked_obstacles.length > 1
    @attributes["Linked Obstacles"] = linked_obstacles_str
  elsif linked_obstacles.length == 1
    @attributes["Linked Obstacle"] = linked_obstacles[0]
  else
    @attributes["Linked Obstacles"] = "None"
  end
  erb(:reader)
end

# Edit form for collectible items
get('/editor/item/update/:id/collectible') do
  @object_name = 'item'
  @options = {
    :header_action => 'Edit',
    :action => "/editor/item/update/#{params[:id].to_i}",
    :object_name => 'item',
    :object_id => params[:id],
    :secret_method => 'patch'
  }

  @fields = {
    :item_name => {
      :field_type => "text",
      :name_and_id => "item_name",
      :label_text => "Item Name"
    }
  }
  erb(:generic_editor)
end

# Edit form for interactable Items
get ('/editor/item/update/:id/interactable') do
  @object_name = "item"
  @options = {
    :header_action => "Create",
    :object_name => "item",
    :object_id => params[:id],
    :action => "/editor/item/update/#{params[:id]}",
    :secret_method => "patch"
  }

  @fields = {
    :item_name => {
      :field_type => "text",
      :name_and_id => "item_name",
      :label_text => "Item Name"},
    :interaction_text => {
      :field_type => "text",
      :name_and_id => "interaction_text",
      :label_text => "Interaction Text"
    },
    :linked_obstacles => {
      :field_type => "checkboxes",
      :section_header => "Linked Obstacles",
      :name_id_prefix => "obstacle",
      :checkable_options => OtherObstacle.all_obstacles
      }
  }
  erb(:generic_editor)
end

# Actually updates an item
patch('/editor/item/update/:id') do
  item = Item.get_item_by_id(params[:id].to_i)
  # Sets item name
  item.set_name(params[:item_name])

  # Clears linked obstacles and applies new ones. Also saves interaction text
  if item.is_a?(InteractableItem)
    item.set_interaction_text(params[:interaction_text])
    item.set_linked_obstacles([])
    obstacle_keys = params.keys.select {|key| key.match?(/obstacle_\d+\b/)}
    obstacles = []
    obstacle_keys.each do |key|
      obstacles.push(Obstacle.get_obstacle_by_id(key.match('\d\b').to_s.to_i))
    end
    item.set_linked_obstacles(obstacles)
  end
  redirect to('/editor/item')
end

# Deletes an item
delete('/editor/item/delete/:id') do
  item = Item.get_item_by_id(params[:id].to_i)
  item.delete
  redirect to('/editor/item')
end

# All for handling obstacle CRUD
get('/editor/obstacle') do
  @object_name = "obstacle"
  @object_name_plural = "obstacles"
  @objects = Obstacle.all_obstacles
  erb(:menu_template)
end

get('/editor/obstacle/create') do
  @object_name = "Obstacle"
  @types = {
    "Item Obstacle" => '/editor/obstacle/create/item',
    "Environmental Obstacle" => '/editor/obstacle/create/environmental'
  }
  erb(:object_type_selector)
end

get('/editor/obstacle/create/item') do
  @options = {
    :header_action => "Create",
    :object_name => "obstacle",
    :action => "/editor/obstacle/create"
  }

  collectible_items = Item.all_collectible_items
  collectible_selections = []
  collectible_items.each do |item|
    collectible_selections.push([item.id, item.name])
  end

  @fields = {
    :item_name => {
      :field_type => "text",
      :name_and_id => "obstacle_name",
      :label_text => "Obstacle Name"
    },
    :block_text => {
      :field_type => "text",
      :name_and_id => "block_text",
      :label_text => "Block Text"
    },
    :pass_text => {
      :field_type => "text",
      :name_and_id => "pass_text",
      :label_text => "Pass Text"
    },
    :required_item => {
      :field_type => "dropdown",
      :name_and_id => "required_item",
      :label_text => "Item required to pass: ",
      :options => collectible_selections
    }
  }
  erb(:generic_editor)
end

get('/editor/obstacle/create/environmental') do
  @options = {
    :header_action => "Create",
    :object_name => "obstacle",
    :action => "/editor/obstacle/create"
  }

  @fields = {
    :item_name => {
      :field_type => "text",
      :name_and_id => "obstacle_name",
      :label_text => "Obstacle Name"
    },
    :block_text => {
      :field_type => "text",
      :name_and_id => "block_text",
      :label_text => "Block Text"
    },
    :pass_text => {
      :field_type => "text",
      :name_and_id => "pass_text",
      :label_text => "Pass Text"
    },
    :clearable_by_default => {
      :field_type => "dropdown",
      :name_and_id => "clearable_by_default",
      :label_text => "Clearable by default?",
      :options => [["false", "No"], ["true", "Yes"]]
    }
  }
  erb(:generic_editor)
end

post('/editor/obstacle/create') do
  # Gets attributs shared between both types of obstacles
  obstacle_name = params[:obstacle_name]
  block_text = params[:block_text]
  pass_text = params[:pass_text]

  # Detects what type of obstacle this needs to be and creates it
  if params.keys.include?("required_item")
    required_item = Item.get_item_by_id(params[:required_item].to_i)
    new_obstacle = ItemObstacle.new(obstacle_name, required_item, block_text, pass_text)
  else
    if params[:clearable_by_default] == "true"
      already_clearable = true
    else
      already_clearable = false
    end
    new_obstacle = OtherObstacle.new(obstacle_name, already_clearable, block_text, pass_text)
  end
  redirect to("editor/obstacle/read/#{new_obstacle.id}")
end

get('/editor/obstacle/read/:id') do
  obstacle = Obstacle.get_obstacle_by_id(params[:id].to_i)
  @attributes = {}

  # Get the unique attribute
  @back_link = "/editor/obstacle"
  if obstacle.is_a?(ItemObstacle)
    required_item = Item.get_item_by_id(obstacle.get_required_item.id)
    @attributes.store("Required Item", required_item.name)
  else
    @attributes.store("Clearable by default", obstacle.initial_state)
  end

  # Gets the obstacle name and common attributes
  @edit_link = "/editor/obstacle/update/#{obstacle.id}"
  @name = obstacle.name
  @attributes["Obstacle Name"] = obstacle.name
  @attributes["Block Text"] = obstacle.block_text
  @attributes["Pass text"] = obstacle.pass_text

  erb(:reader)
end

# Form for updating an obstacle
get('/editor/obstacle/update/:id') do
  @obstacle = Obstacle.get_obstacle_by_id(params[:id].to_i)
  @object_name = "obstacle"
  @options = {
    :header_action => "Edit",
    :action => "/editor/obstacle/update/#{@obstacle.id}",
    :object_name => "obstacle",
    :object_id => @obstacle.id,
    :secret_method => 'patch'
  }
  @fields = {
    :item_name => {
      :field_type => "text",
      :name_and_id => "obstacle_name",
      :label_text => "Obstacle Name"
    },
    :block_text => {
      :field_type => "text",
      :name_and_id => "block_text",
      :label_text => "Block Text"
    },
    :pass_text => {
      :field_type => "text",
      :name_and_id => "pass_text",
      :label_text => "Pass Text"
    },
    :unique_attributes => {
      :field_type => "dropdown"
    }
  }

  if @obstacle.is_a?(ItemObstacle)
    collectible_items = Item.all_collectible_items
    collectible_selections = []
    collectible_items.each do |item|
      collectible_selections.push([item.id, item.name])
    end
    @fields[:unique_attributes][:name_and_id] = "required_item"
    @fields[:unique_attributes][:label_text] = "Item required to pass"
    @fields[:unique_attributes][:options] = collectible_selections
  else
    @fields[:unique_attributes][:name_and_id] = "clearable_by_default"
    @fields[:unique_attributes][:label_text] = "Clearable by default?"
    @fields[:unique_attributes][:options] = [["false", "No"], ["true", "Yes"]]
  end
  erb(:generic_editor)
end

# Actually updates the obstacle
patch('/editor/obstacle/update/:id') do
  obstacle = Obstacle.get_obstacle_by_id(params[:id].to_i)
  obstacle.set_name(params[:obstacle_name])
  obstacle.set_block_text(params[:block_text])
  obstacle.set_pass_text(params[:pass_text])

  if(obstacle.is_a?(OtherObstacle))
    if params[:clearable_by_default] == "true"
      obstacle.set_initial_state(true)
    else
      obstacle.set_initial_state(false)
    end
  else
    obstacle.set_required_item(Item.get_item_by_id(params[:required_item].to_i))
  end
  redirect to("/editor/obstacle/read/#{obstacle.id}")
end

# Deletes an obstacle
delete('/editor/obstacle/delete/:id') do
  obstacle = Obstacle.get_obstacle_by_id(params[:id].to_i)
  obstacle.delete
  redirect to("/editor/obstacle")
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
  else
    selected_obstacle = Obstacle.get_obstacle_by_id(params[:obstacle].to_i)
  end
  Path.new(params[:room_a].to_i, params[:room_a_direction].to_sym,
    params[:room_b].to_i, params[:room_b_direction].to_sym, selected_obstacle)
  redirect to('/editor/path')
end

# Displays a path's details
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

get('/editor/path/update/:id') do
  path = Path.get_path_by_id(params[:id].to_i)
  @options = {
    :header_action => "Update",
    :action => "/editor/path/update/#{path.id}",
    :secret_method => "patch",
    :path_id => path.id
  }
  erb(:path_editor)
end

# Actually updates the Path
patch('/editor/path/update/:id') do
  # Gets info needed for updating(except for obstacle)
  path_to_update = Path.get_path_by_id(params[:id].to_i)
  room_a = Room.get_room_by_id(params[:room_a].to_i)
  direction_a = params[:room_a_direction].to_sym
  room_b = Room.get_room_by_id(params[:room_b].to_i)
  direction_b = params[:room_b_direction].to_sym

  # updates all non-obstacle attributes
  path_to_update.update_room_a(room_a, direction_a)
  path_to_update.update_room_b(room_b, direction_b)

  #Updates the obstacle or sets it to nil as neccessary
  if(params[:obstacle] != "None")
    path_to_update.update_obstacle(params[:obstacle].to_i)
  else
    path_to_update.update_obstacle(nil)
  end

  # Saves changes to path
  path_to_update.update

  redirect to("/editor/path/read/#{path_to_update.id}")
end

# Deletes a path
delete('/editor/path/delete/:id') do
  Path.get_path_by_id(params[:id].to_i).delete
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
