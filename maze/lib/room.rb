class Room
  @@all_rooms = {}
  @@room_count = 0
  @@start_room = nil
  @@end_room = nil

  attr_accessor :items, :paths, :id

  def initialize(items={}, name=nil)
    @paths = {:north => nil, :south => nil, :east => nil, :west => nil}
    @id = @@room_count
    @items = items
    @item_log = {}
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

  # Adds an item to itself
  def add_item(item)
    @items[item.id] = item
    @@all_rooms[@id] = self
    update_item_log

  end

  # adds all items ever added to the room back
  def restore_items
    @items = @item_log
    update
  end

  # Updates item log
  def update_item_log
    @items.keys.each do |item_key|
      @item_log.store(item_key, @items[item_key])
    end
    update
  end

  # Updates itself in the mock db
  def update
    @@all_rooms[@id] = self
  end

  # Changes one of the room's paths
  def update_paths(direction, path)
    @paths[direction] = path
    @@all_rooms[@id] = self
  end

  # Changes the name of the room
  def set_name(new_name)
    @name = new_name
    @@all_rooms[@id] = self
  end

  def get_path(direction)
    return @paths[direction]
  end

  # Removes all items from the room
  def clear_items
    @items = {}
    @@all_rooms[@id] = self
  end

  def self.get_room_by_id(id)
    @@all_rooms[id]
  end

  # Removes itself from the database
  def delete
    @@all_rooms.delete(@id)
  end

  def self.all_rooms
    @@all_rooms.values
  end

  def self.clear
    @@all_rooms = {}
    @@room_count = 0
  end

  def self.start_room
    @@start_room
  end

  def self.end_room
    @@end_room
  end

  def set_start_room
    @@start_room = self
  end

  def set_end_room
    @@end_room = self
  end

  # Returns the name of the room. If the name is the same as the id, returns
  # "Room #<id>" instead
  def name
    if @name == @id
      return "Room \##{@id}"
    else
      return @name
    end
  end

end
