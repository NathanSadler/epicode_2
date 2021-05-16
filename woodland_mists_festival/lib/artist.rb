class Artist
  @@all_artists = {}
  @@artist_count = 0

  attr_reader :name, :id, :stage_id

  def initialize(name, stage_id=nil)
    @name = name
    @stage_id = stage_id
    @id = @@artist_count
    @@all_artists[@id] = self
    @@artist_count += 1
  end

  # True if name, id, and stage_id are all equal
  def ==(other_artist)
    (self.name == other_artist.name) && (self.id == other_artist.id) && (
      self.stage_id == other_artist.stage_id)
  end

  # Updates artist's name
  def update_name(new_name)
    @name = new_name
    @@all_artists[@id] = self
  end

  # Updates artist's stage id
  def update_stage(new_stage_id)
    @stage_id = new_stage_id
    @@all_artists[@id] = self
  end

  # Gets all artists
  def self.all_artists
    return @@all_artists.values
  end

  # Gets name of artist's stage. Returns 'no stage' if the artist doesn't have a
  # valid stage id
  def get_stage_name
    if (Stage.stage_ids.include?(@stage_id))
      Stage.get_stage_with_id(@stage_id).name
    else
      'no stage'
    end
  end

  # Clears all artists
  def self.clear
    @@all_artists = {}
    @@artist_count = 0
  end

  # Deletes itself from all_artists
  def delete
    @@all_artists.delete(@id)
  end

end
