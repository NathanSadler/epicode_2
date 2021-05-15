require('rspec')
require('artist')
require('stage')

describe '#Artist' do
  before(:each) do
    @stage_1 = Stage.new("Great Deku Tree")
    @stage_2 = Stage.new("Creepy Cabin in the Woods")
    @artist_1 = Artist.new("Metal Blimp", @stage_1.id)
    @artist_2 = Artist.new("Stationary Boulder")
    @artist_3 = Artist.new("Metallic", 3)
  end

  after(:each) do
    Stage.clear
    Artist.clear
  end

  describe('#update_name') do
    it("changes an artist's name") do
      @artist_1.update_name("Iron Airship")
      expect(@artist_1.name).to(eq("Iron Airship"))
      expect(Artist.all_artists[0].name).to(eq("Iron Airship"))
    end
  end

  describe('#update_stage') do
    it("Changes an artist's stage id") do
      @artist_1.update_stage(@stage_2.id)
      expect(@artist_1.stage_id).to(eq(@stage_2.id))
      expect(Artist.all_artists[0].stage_id).to(eq(@stage_2.id))
    end
  end

  describe('#get_stage_name') do
    it("Gets the name of an artist's stage") do
      expect(@artist_1.get_stage_name).to(eq("Great Deku Tree"))
    end

    it("Returns 'no stage' if the artist's stage id is nil") do
      expect(@artist_2.get_stage_name).to(eq("no stage"))
    end

    it("Returns 'no stage' if there is no stage that has the artist's " +
    "stage id") do
      expect(@artist_3.get_stage_name).to(eq("no stage"))
    end
  end

  describe('#delete') do
    before(:each) do
      @artist_1.delete
    end

    it("deletes itself from all_stages") do
      expect(Artist.all_artists.include?(@artist_1)).to(eq(false))
    end
    it("doesn't delete other stages from all_stages") do
      expect(Artist.all_artists.include?(@artist_2)).to(eq(true))
      expect(Artist.all_artists.include?(@artist_3)).to(eq(true))
    end
  end
end
