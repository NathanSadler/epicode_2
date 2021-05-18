class Item
  @@all_items = {}
  @@item_count = 0

  def initialize(name)
    @name = name
    @id = @@item_count
    @@all_items[@id] = self
    @@item_count += 1
  end

  def ==(other_item)
    (self.name == other_item.name) && (self.id == other_item.id)
  end

  # Returns a list containing every Item object
  def self.all_items
    @@all_items.values
  end

  # Deletes itself from all_items
  def delete
    @@all_items.delete(@id)
  end

  def self.clear
    @@all_items = {}
    @@item_count = 0
  end
end

# An item that switches the state of one or more obstacles
class InteractableItem < Item
  def initialize(name, linked_obstacles)
    super(name)
    @linked_obstacles = linked_obstacles
    @@all_items[@id] = self
  end

  # Switches state of the linked obstacles
  def change_obstacle_states
    @linked_obstacles.each do |i|
      i.switch_state
    end
  end
end