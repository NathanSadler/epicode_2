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

  # Modifies this item in the mock db
  def update
    @@all_items[@id] = self
  end

  def id
    @id
  end

  def set_name(new_name)
    @name = new_name
    update
  end

  def name
    @name
  end

  # Returns a list containing every Item object
  def self.all_items
    @@all_items.values
  end

  def self.all_collectible_items
    all_items.select {|item| !item.is_a?(InteractableItem)}
  end

  def self.item_hash
    @@all_items
  end


  def self.get_item_by_id(id)
    return @@all_items[id]
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
  def initialize(name, linked_obstacles, interaction_text = nil)
    super(name)
    @linked_obstacles = linked_obstacles
    @@all_items[@id] = self
    @interaction_text = interaction_text
  end

  def interaction_text
    @interaction_text
  end

  def linked_obstacles
    @linked_obstacles
  end

  def self.all_interactable_items
    all_items.select {|item| item.is_a?(InteractableItem)}
  end

  # linked_obstacles should be an array
  def set_linked_obstacles(linked_obstacles)
    @linked_obstacles = linked_obstacles
    update
  end

  # Switches state of the linked obstacles
  def change_obstacle_states
    @linked_obstacles.each do |i|
      i.switch_state
    end
  end
end
