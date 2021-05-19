class Board
  @@all = {}
  @@counter = 0

  attr_accessor :name, :timestamp, :id

  def initialize(name)
    @name = name
    @timestamp = DateTime.now
    @id = nil
  end

  # Saves this board to the mock db, or just updates it
  def save
    if id.nil? || (@@counter == 0)
      @id = @@counter
      @@counter += 1
    end
    @@all[@id] = self
  end

  def ==(other_board)
    (self.name == other_board.name) && (self.timestamp == other_board.timestamp) &&
    (self.id == other_board.id)
  end

  def self.all
    @@all.values
  end

  def self.master_hash
    @@all
  end

  def get_url
    "/board/#{id}/messages"
  end

  # Gets url for creating a board
  def self.get_creation_url
    "/board/create"
  end

  def self.clear
    @@all = {}
    @@counter = 0
  end

  def self.sort_by_timestamp
    @@all.values.sort_by(&:timestamp)
  end

  def self.sort_by_name
    temp = @@all.values
    final = temp.sort_by {|board| board.name.downcase}
    final
  end

  def delete
    @@all.delete(@id)
  end

end
