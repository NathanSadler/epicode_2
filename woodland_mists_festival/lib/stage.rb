class Stage
  @@all_stages = {}
  @@stage_count = 0

  attr_reader :name, :id

  def initialize(name)
    @name = name
    @id = @@stage_count
    @@stage_count += 1
    @@all_stages[@id] = self
  end

  def self.clear
    @@all_stages.clear
    @@stage_count = 0
  end

  # Changes the stage's name
  def update(new_name)
    @name = new_name
    @@all_stages[@id] = self
  end

  # True if ID and name are equal
  def ==(other_stage)
    (self.name == other_stage.name) && (self.id == other_stage.id)
  end

  # Deletes itself from all_stages
  def delete
    @@all_stages.delete(self.id)
  end

  # Returns a list of all stages
  def self.all_stages
    return @@all_stages.values
  end

  # Returns the number of stages
  def self.stage_count
    return @@stage_count
  end

  # Returns a list of stage IDs
  def self.stage_ids
    return @@all_stages.keys
  end

  # Returns the stage with the specified ID. Returns 'no stage' if there isn't one
  def self.get_stage_with_id(given_id)
    if(@@all_stages.keys.include?(given_id))
      @@all_stages[given_id]
    else
      'no stage'
    end
  end

end
