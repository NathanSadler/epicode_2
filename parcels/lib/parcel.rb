class Parcel
  attr_reader :length, :width, :height, :weight, :id

  @@parcels = {}
  @@total_rows = 0

  def initialize(length, width, height, weight, id=nil)
    @length = length
    @width = width
    @height = height
    @weight = weight
    @id = id || @@total_rows += 1
  end

  def save
    @@parcels[@id] = Parcel.new(@length, @width, @height, @weight, @id)
  end

  # Return a list of all parcels in the mock database
  def self.all
    @@parcels.values
  end

  # True if the length, width, height, weight, and ID match the other's
  def ==(other_parcel)
    ((self.length == other_parcel.length) && (self.width == other_parcel.width) &&
  (self.height == other_parcel.height) && (self.weight == other_parcel.weight) &&
(self.id == other_parcel.id))
  end

  # Removes all parcels from the mock database
  def self.clear
    @@parcels = {}
    @@total_rows = 0
  end

  # Updates itself.
  def update(length=nil, width=nil, height=nil, weight=nil)
    @length = length || @length
    @width = width || @width
    @height = height || @height
    @weight = weight || @weight
  end

  # Deletes itself from the mock database
  def delete
    @@parcels.delete(@id)
  end

  # Returns the parcel with the specified ID
  def self.find(id)
    @@parcels.fetch(id)
  end

end
