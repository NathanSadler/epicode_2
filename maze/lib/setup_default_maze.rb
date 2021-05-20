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
  Path.new(room_list[2], :south, room_list[3], :north)

  # Creates player
  Player.new

end
