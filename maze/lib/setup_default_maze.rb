def setup_default_maze
  # Clears everything
  Item.clear
  Obstacle.clear
  Path.clear
  Player.clear
  Room.clear

  # Creates Rooms
  room_list = []
  7.times {room_list.append(Room.new)}

  # Creates paths between rooms
  Path.new(room_list[0], :north, room_list[1], :south)
  Path.new(room_list[0], :east, room_list[2], :west)
  locked_door_path = Path.new(room_list[1], :north, room_list[5], :south)
  Path.new(room_list[2], :south, room_list[3], :north)
  large_gap_path = Path.new(room_list[2], :east, room_list[6], :west)
  Path.new(room_list[3], :south, room_list[4], :north)

  # Create collectible item(s)
  key = Item.new("key")

  # Creates OtherObstacle(s)
  large_gap = OtherObstacle.new("large gap", false, "A large gap prevents you "+
  "from passing.", "There is a large gap here, but a bridge was lowered, "+
  "allowing you to pass.")

  # Creates ItemObstacle(s)
  locked_door = ItemObstacle.new("locked door", key,
    "The door to this path is locked.", "The door to this path is locked, but " +
  "you are able to unlock it with your key.")

  # Creates InteractableItem object(s)
  lever = InteractableItem.new("lever", [large_gap], "Flick Lever")

  # Applies obstacles to Paths
  locked_door_path.obstacle = locked_door
  large_gap_path.obstacle = large_gap

  # Adds items to rooms
  room_list[4].add_item(key)
  room_list[5].add_item(lever)

  # Selects the "ending" room
  room_list[0].set_start_room
  room_list[6].set_end_room

  # Creates player
  Player.new

end
