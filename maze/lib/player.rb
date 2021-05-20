class Player
  @@current_player = nil
  @current_room_id
  @inventory

  attr_reader :current_room_id, :inventory

  # Creates a new player
  def initialize(starting_room_id = 0)
    @current_room_id = starting_room_id
    @inventory = []
    update
  end

  # Returns the current player
  def self.current_player
    return @@current_player
  end

  # Returns the Room object the player is in
  def current_room
    Room.get_room_by_id(@current_room_id)
  end

  # Moves the player to the room with the given room ID
  def move_to_room(room_id)
    if Room.get_room_by_id(room_id)
      @current_room_id = room_id
      update
    end
  end

  #Adds an item to the player's inventory
  def add_to_inventory(item)
    @inventory.push(item)
    update
  end

  # Resets the player
  def self.clear
    @current_room_id = 0
    @inventory = []
  end

  # Updates current_player
  def update
    @@current_player = self
  end

end
