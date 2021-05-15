class Album

  attr_reader :name, :id, :year, :genre, :artist
  @@albums = {}
  @@sold_albums = {}
  @@total_rows = 0

  def initialize(name, id=nil, year=nil, genre=nil, artist=nil)
    @name = name
    @id = id || @@total_rows += 1
    @year =  year
    @genre = genre || "Unknown Genre"
    @artist = artist || "Unknown Artist"
  end

  # Saves this album to the mock database
  def save
    @@albums[self.id] = Album.new(self.name, self.id, self.year, self.genre,
    self.artist)
  end

  # Returns a list of the names of all albums in the mock database
  def self.all
    return @@albums.values
  end

  # Returns a list of all albums in the sold_albums hash
  def self.sold_albums
    return @@sold_albums.values
  end

  # Returns a specified album from the mock database
  def self.find(id)
    @@albums[id]
  end

  # Updates its name. Doesn't change the mock database
  def update(name)
    @name = name
  end

  # Deletes its entry from the mock database
  def delete
    @@albums.delete(self.id)
  end

  # Empties the mock database
  def self.clear
    @@albums = {}
    @@total_rows = 0
    @@sold_albums = {}
  end

  # True if name and ID of both are same
  def ==(other_album)
    (self.id == other_album.id) && (self.name == other_album.name)
  end

  # Searches for an album by name and returns a list of matches
  def self.search(album_name)
    @@albums.values.select {|album| album.name.match?("#{album_name}")}
  end

  # Returns a list of albums sorted by name
  def self.sort
    mock_db_copy = @@albums.values
    mock_db_copy.sort_by! {|album| album.name}
  end

  # Moves this album to the sold hash
  def sold
    @@sold_albums[self.id] = @@albums.delete(self.id)
  end

  def songs
    Song.find_by_album(self.id)
  end

end
