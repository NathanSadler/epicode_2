require 'rspec'
require 'album'


describe '#Album' do

  # Creates and saves albums to use before each test
  before(:each) do
    @album = Album.new("Foo Beats", nil, 1984, "Rock", "The Bombadier Beetles")
    @album2 = Album.new("Bar Bars", nil, 1987, "Pop", "The Stationary Stones")
    @album.save
    @album2.save
  end

  after(:each) do
    Album.clear
  end

  describe('.all') do
    it("Returns a list of the names of each album in the database") do
      @album.save
      expect(Album.all).to(eq([@album, @album2]))
    end

    it("Returns an empty list if there are no values in the mock database") do
      Album.clear
      expect(Album.all).to(eq([]))
    end
  end

  describe('.find') do
    it("Returns the album from the mock database with the given ID") do
    expect(Album.find(1)).to(eq(@album))
    end
  end

  describe('#update') do
    before(:each) do
      @album.update("Foo's Firey Beats")
    end
    it("Updates its name") do
      expect(@album.name).to(eq("Foo's Firey Beats"))
    end
    it("Doesn't update the mock database before saving") do
      expect(Album.find(1).name).to(eq("Foo Beats"))
    end
  end

  describe('#delete') do
    it("Removes its entry from the database") do
      @album.delete
      expect(Album.all).to(eq([@album2]))
    end
  end

  describe('.clear') do
    it("Empties the mock database") do
      Album.clear
      expect(Album.all).to(eq([]))
    end
  end

  describe('.search') do
    it("Returns a list of all albums that contain a specified string in their" +
    " name") do
      album3 = Album.new("Lorem Ipsum Foo", nil, 2006, "Jazz", "Metal Blimp")
      album3.save
      expect(Album.search("Foo")).to(eq([@album, album3]))
    end
  end

  describe('.sort') do
    it("Returns a list of albums sorted by name") do
      expect(Album.sort).to(eq([@album2, @album]))
    end
  end

  describe('#sold') do
    it("Removes itself from @@albums and puts it in @@sold_albums") do
      @album2.sold
      expect(Album.all.include?(@album2)).to(eq(false))
    end
  end

  describe('.sold_albums') do
    it("Returns a list of all albums in the @@sold_albums hash") do
      @album.sold
      expect(Album.sold_albums).to(eq([@album]))
    end
  end

end
