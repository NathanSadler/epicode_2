class Path
  @@all_paths = {}
  @@path_count = 0

  attr_accessor :room_a, :room_b, :direction_a, :direction_b, :obstacle, :id, :obs_id

  # Creates a path. Room_a and room_b are the rooms the path connects.
  # Direction_a and direction_b indicate which walls of the rooms enter the
  # pathway. Obstacle is an... obstacle
  def initialize(room_a, direction_a, room_b, direction_b=nil, obstacle=nil)
    if (room_a.is_a?(Integer)) && (room_b.is_a?(Integer))
      @room_a = Room.get_room_by_id(room_a)
      @room_b = Room.get_room_by_id(room_b)
    else
      @room_a = room_a
      @room_b = room_b
    end
    @direction_a = direction_a
    @direction_b = direction_b || Path.get_opposite_direction(direction_a)
    @obstacle = obstacle
    @obs_id = nil
    if !obstacle.nil?
      @obs_id = obstacle.id
    end
    @id = @@path_count
    @@all_paths[@id] = self
    @@path_count += 1
    @room_a.update_paths(direction_a, self)
    @room_b.update_paths(direction_b, self)
  end

  def ==(other_path)
    (self.id == other_path.id)
  end

  # Updates itself in the mock database
  def update
    @@all_paths[@id] = self
  end

  # Updates the obstacle. If the given argument is an integer, it sets the
  # obstacle to the obstacle with that integer as its id
  def update_obstacle(new_obstacle)
    if(new_obstacle.is_a?(Integer))
      @obstacle = Obstacle.get_obstacle_by_id(new_obstacle)
    else
      @obstacle = new_obstacle
    end
    @@all_paths[@id] = self
  end

  # Updates room a
  def update_room_a(new_room, new_direction)
    if(new_room.is_a?(Integer))
      @room_a = Room.get_room_by_id(new_room)
    else
      @room_a = new_room
    end
    @direction_a = new_direction
    @@all_paths[@id] = self
    @room_a.update_paths(new_direction, self)
  end

  # Updates room b
  def update_room_b(new_room, new_direction)
    if(new_room.is_a?(Integer))
      @room_b = Room.get_room_by_id(new_room)
    else
      @room_b = new_room
    end
    @direction_b = new_direction
    @@all_paths[@id] = self
    @room_b.update_paths(new_direction, self)
  end

  def self.clear
    @@all_paths = {}
    @@path_count = 0
  end

  def restore_obstacle
    if !@obs_id.nil?
      binding.pry
      update_obstacle(@obs.id)
      update
    end
  end

  # Returns true if the path has no obstacle or the obstacle can be cleared. It
  # also needs to have a room on both ends
  def can_pass?(inventory=Player.current_player.inventory)
    if @room_a == nil || @room_b == nil
      return false
    elsif !@obstacle.nil? && !@obstacle.can_pass?(inventory)
      return false
    else
      return true
    end
  end

  def self.get_path_by_id(id)
    return @@all_paths[id]
  end

  # Returns a string. It should be formatted like 'Path from <room a name> to
  # <room b name>'
  def name
    "Path from #{@room_a.name} to #{@room_b.name}"
  end

  # Tries to travel along the path. If successful, returns the room on the end
  # of the path that is NOT the room being travelled from. If the starting point
  # is not on the path, returns nil. If the starting point is valid but an
  # obstacle blocks the path, returns block_text. Also, if there is an
  # ItemObstacle that the player is able to clear, the obstacle gets set to
  # nil
  def travel_from(starting_room)
    if (starting_room != @room_a) && (starting_room != @room_b)
      return nil
    end
    if self.can_pass?
      foo = [@room_a, @room_b].select {|room| room != starting_room}
      if(!@obstacle.nil? && @obstacle.is_a?(ItemObstacle))
        @obstacle = nil
        @@all_paths[@id] = self
      end
      return foo[0]
    else
      return @obstacle.block_text
    end
  end

  def self.all_paths
    return @@all_paths.values
  end

  # Deletes itself
  def delete
    @@all_paths.delete(@id)
  end

  # Returns the direction opposite of whatever was given
  def self.get_opposite_direction(direction)
    directions_a = {1 => :north, -1 => :south, 2 => :east, -2 => :west}
    directions_b = {:north => 1, :south => -1, :east => 2, :west => -2}
    directions_a[directions_b[direction] * -1]
  end

end
