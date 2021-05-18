class Path
  @@all_paths = {}
  @@path_count = 0

  attr_accessor :room_a, :room_b, :direction_a, :direction_b, :obstacle, :id

  # Creates a path. Room_a and room_b are the rooms the path connects.
  # Direction_a and direction_b indicate which walls of the rooms enter the
  # pathway. Obstacle is an... obstacle
  def initialize(room_a, direction_a, room_b, direction_b, obstacle=nil)
    @room_a = room_a
    @room_b = room_b
    @direction_a = direction_a
    @direction_b = direction_b
    @obstacle = obstacle
    @id = @@path_count
    @@all_paths[@id] = self
    @@path_count += 1
    @room_a.update_paths(direction_a, self)
    @room_b.update_paths(direction_b, self)
  end

  def ==(other_path)
    (self.id == other_path.id)
  end

  def self.clear
    @@all_paths = {}
    @@path_count = 0
  end

  # Returns true if the path has no obstacle or the obstacle can be cleared. It
  # also needs to have a room on both ends
  def can_pass?
    if @room_a == nil || @room_b == nil
      return false
    elsif !@obstacle.nil? && !@obstacle.can_pass?
      return false
    else
      return true
    end
  end

  # Tries to travel along the path. If successful, returns the room on the end
  # of the path that is NOT the room being travelled from. If the starting point
  # is not on the path, returns nil. If the starting point is valid but an
  # obstacle blocks the path, returns block_text
  def travel_from(starting_room)
    if (starting_room != @room_a) && (starting_room != @room_b)
      return nil
    end
    if self.can_pass?
      foo = [@room_a, @room_b].select {|room| room != starting_room}
      return foo[0]
    else
      return @obstacle.block_text
    end
  end

end
