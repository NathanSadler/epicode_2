class Obstacle
  @@obstacle_list = {}

  attr_accessor = :pass_text

  # Path is the path the obstacle is in
  def initialize(name, block_text=nil, pass_text=nil, path=nil)
    @name = name
    @block_text = block_text
    @pass_text = pass_text
    @path = path
    @@obstacle_list[name] = self
  end

  def self.all_obstacles
    @@obstacle_list.values
  end

  def ==(other_obstacle)
    (self.block_text == other_obstacle.block_text) &&
    (self.pass_text == other_obstacle.pass_text) &&
    (self.name == other_obstacle.name)
  end

  def delete
    @@obstacle_list.delete(@name)
  end

  def self.get_obstacle_by_name(name)
    @@obstacle_list[name]
  end

  def block_text
    @block_text
  end

  def name
    @name
  end

  # Returns an array where the keys are the doors of the rooms and the values
  # are lists of obstacles that have that rooms as either door_a or door_b
  def self.get_blocked_paths
    blocked_doors = {}
  end

  def self.clear
    @@obstacle_list = {}
  end
end


#An obstacle that requires a certain item to pass
class ItemObstacle < Obstacle
  def initialize(name, required_item, block_text=nil, pass_text=nil)
    super(name, block_text=block_text, pass_text=pass_text)
    @required_item = required_item
    @@obstacle_list[name] = self
  end

  # Only returns true if the required item is in inventory
  def can_pass?(inventory)
    inventory.include?(@required_item)
  end
end

class OtherObstacle < Obstacle

  def initialize(name, current_state=false, block_text=nil, pass_text=nil)
    super(name, block_text, pass_text)
    @current_state = current_state
    @@obstacle_list[name] = self
  end

  # Switches the current_state. Returns new state
  def switch_state
    @current_state = !@current_state
    @@obstacle_list[@name] = self
    @current_state
  end

  # Returns true if current_state is true
  def can_pass?
    @current_state
  end
end