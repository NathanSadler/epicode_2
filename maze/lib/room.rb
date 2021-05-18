class Room
  @@all_rooms = {}
  @@room_count = 0
  @@start_room = nil
  @@end_room = nil

  attr_accessor :items, :paths, :name, :id

  def initialize(items={}, name=nil)
    @paths = {:north => nil, :south => nil, :east => nil, :west => nil}
    @id = @@room_count
    @items = items
    @name = name || @id
    @@all_rooms[@id] = self
    @@room_count += 1
  end

  # Tries to use a path. Won't go anywhere if the player does not have
  # an item they need, there is another obstacle in their way or there isn't a
  # path in the given direction. Direction refers to THIS room's doors, not the
  # previous room's. Returns whatever room the player winds up in
  def use_path(direction)
    if !@paths[direction].nil?
      return @paths[direction].travel_from(self)
    end
  end

  # Changes one of the room's paths
  def update_paths(direction, path)
    @paths[direction] = path
    @@all_rooms[@id] = self
  end

  def get_path(direction)
    return @paths[direction]
  end

  def self.get_room_by_id(id)
    @@all_rooms[id]
  end


  def self.all_rooms
    @@all_rooms.values
  end

  def self.clear
    @@all_rooms = {}
    @@room_count = 0
  end

  def start_room
    @@start_room
  end

  def end_room
    @@end_room
  end

  def set_start_room
    @@start_room == self
  end

  def set_end_room
    @@end_room == self
  end

end
