class Record

  attr_reader :name, :id

  @@records = {}
  @@total_rows = 0

  def initialize(name, id=nil)
    @name = name
    @id = id || @@total_rows += 1
  end

  # Saves this record to the mock database
  def save
    @@records[self.id] = Record.new(self.name, self.id)
  end

  # Returns a list of the names of all records in the mock database
  def self.all
    return @@records.values
  end

  # Returns a specified record from the mock database
  def self.find(id)
    @@records[id]
  end

  # Updates its name. Doesn't change the mock database
  def update(name)
    @name = name
  end

  # Deletes its entry from the mock database
  def delete
    @@records.delete(self.id)
  end

  # Empties the mock database
  def self.clear
    @@records = {}
    @@total_rows = 0
  end

  # True if name and ID of both are same
  def ==(other_record)
    (self.id == other_record.id) && (self.name == other_record.name)
  end

end
