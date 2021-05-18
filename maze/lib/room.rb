class Room
  @@all_rooms = {}
  @@room_count = 0

  attr_accessor :items, :paths

  def initialize(north=nil, south=nil, east=nil, west=nil, items={})
    @paths = {:north => north, :south => south, :east => east, :west => west}
    @id = @@room_count
    @items = items
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


  def self.all_rooms
    @@all_rooms.values
  end

  def self.clear
    @@all_rooms = {}
    @@room_count = 0
  end

end
