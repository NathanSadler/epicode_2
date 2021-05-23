class Obstacle
  @@obstacle_list = {}
  @@obstacle_count = 0

  # Path is the path the obstacle is in
  def initialize(name, block_text=nil, pass_text=nil, path=nil)
    @name = name
    @block_text = block_text
    @pass_text = pass_text
    @path = path
    @id = @@obstacle_count
    @@obstacle_count += 1
    @@obstacle_list[name] = self
  end

  def update
    @@obstacle_list[@name] = self
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

  def pass_text
    @pass_text
  end

  def id
    @id
  end

  def name
    @name
  end

  # Deletes the verison of itself in the mock db, changes its name, and then
  # adds itself back to the mock db using the new name as a key.
  def set_name(new_name)
    @@obstacle_list.delete(@name)
    @name = new_name
    @@obstacle_list[new_name] = self
  end

  def set_block_text(new_text)
    @block_text = new_text
    update
  end

  def set_pass_text(new_text)
    @pass_text = new_text
    update
  end

  # Returns an array where the keys are the doors of the rooms and the values
  # are lists of obstacles that have that rooms as either door_a or door_b
  def self.get_blocked_paths
    blocked_doors = {}
  end

  def self.get_obstacle_by_id(id)
    (@@obstacle_list.values.select {|obs| obs.id == id})[0]
  end

  def self.clear
    @@obstacle_list = {}
    @@obstacle_count = 0
  end
end


#An obstacle that requires a certain item to pass
class ItemObstacle < Obstacle
  def initialize(name, required_item, block_text=nil, pass_text=nil)
    super(name, block_text=block_text, pass_text=pass_text)
    @required_item = required_item
    @@obstacle_list[name] = self
  end

  def self.all_obstacles
    complete_list = Obstacle.all_obstacles
    complete_list.select {|ob| ob.is_a?(ItemObstacle)}
  end

  def get_required_item
    return @required_item
  end

  # new item should be an item object and not an integer
  def set_required_item(new_item)
    @required_item = new_item
    update
  end

  # Only returns true if the required item is in inventory
  def can_pass?(inventory)
    inventory.include?(@required_item)
  end
end

class OtherObstacle < Obstacle

  attr_reader :initial_state

  def initialize(name, current_state=false, block_text=nil, pass_text=nil)
    super(name, block_text, pass_text)
    @current_state = current_state
    @initial_state = current_state
    @@obstacle_list[name] = self
  end

  # Returns a list of every OtherObstacle object
  def self.all_obstacles
    complete_list = Obstacle.all_obstacles
    complete_list.select {|foo| foo.is_a?(OtherObstacle)}
  end

  def set_initial_state(new_initial_state)
    @initial_state = new_initial_state
    update
  end

  # Sets the obstacle to a specific state
  def set_state(state)
    @current_state = state
  end

  def self.set_all_to_default
    OtherObstacle.all_obstacles.map {|obs| obs.set_state(obs.initial_state)}
  end

  # Switches the current_state. Returns new state
  def switch_state
    @current_state = !@current_state
    @@obstacle_list[@name] = self
    @current_state
  end

  # Returns true if current_state is true
  def can_pass?(inventory=[])
    @current_state
  end
end
