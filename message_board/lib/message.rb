class Message
  @@all = {}
  @@counter = 0

  attr_accessor :name, :timestamp, :id, :content, :board_id

  def initialize(name, board_id, content)
    @name = name
    @timestamp = DateTime.now
    @id = nil
    @content = content
    @board_id = board_id
  end

  # Saves this message to the mock db, or just updates it
  def save
    if id.nil? || (@@counter == 0)
      @id = @@counter
      @@counter += 1
    end
    @@all[@id] = self
  end

  def ==(other_message)
    (self.name == other_message.name) && (self.timestamp == other_message.timestamp) &&
    (self.id == other_message.id)
  end

  def self.all
    @@all.values
  end

  def self.clear
    @@all = {}
    @@counter = 0
  end

  # Gets all messages in the board with id board__id
  def self.get_messages_in_board(board__id)
    @@all.values.select {|foo| foo.board_id == board__id}
  end

  def self.sort_by_timestamp
    @@all.values.sort_by(&:timestamp)
  end

  def self.sort_by_name
    temp = @@all.values
    final = temp.sort_by {|message| message.name.downcase}
    final
  end

  def get_board
    Board.master_hash[@board_id]
  end

  def get_url
    "/board/#{@board_id}/messages/#{@id}"
  end

  # Gets url for creating a message
  def self.get_creation_url(board_id)
    "/board/#{board_id}/messages/create"
  end

  def self.get_message_by_id(id)
    @@all[id]
  end

end
