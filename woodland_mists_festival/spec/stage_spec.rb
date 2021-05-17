require('rspec')
require('stage')
require('artist')

describe '#Stage' do
  before(:each) do
    Stage.clear
    @stage_1 = Stage.new("Great Deku Tree")
    @stage_2 = Stage.new("Creepy Cabin in the Woods")
  end

  after(:each) do
    Stage.clear
  end

  describe('.all_stages') do
    it("returns a list of every stage") do
      expect(Stage.all_stages.include?(@stage_1)).to(eq(true))
    end
  end

  describe('.clear') do
    it("empties the list of stages") do
      Stage.clear
      expect(Stage.all_stages.empty?).to(eq(true))
    end
  end

  describe('#update') do
    it("updates the stage's name") do
      @stage_1.update("Greater Deku Tree")
      expect(Stage.all_stages[0].name == "Greater Deku Tree").to(eq(true))
    end
  end

  describe('#delete') do
    before(:each) do
      @stage_2.delete
    end

    it("deletes itself from all_stages") do
      expect(Stage.all_stages.include?(@stage_2)).to(eq(false))
    end

    it("doesn't delete other stages from all_stages") do
      expect(Stage.all_stages.include?(@stage_1)).to(eq(true))
    end
  end

  describe('.stage_ids') do
    it("returns a list of every stage's id") do
      expect(Stage.stage_ids).to(eq([@stage_1.id, @stage_2.id]))
    end
  end

  describe('.get_stage_with_id') do
    it("returns the stage with the specified id") do
      expect(Stage.get_stage_with_id(@stage_1.id)).to(eq(@stage_1))
    end

    it("returns 'no stage' if there isn't a stage with the specified id") do
      expect(Stage.get_stage_with_id(724)).to(eq('no stage'))
    end
  end

  describe('#get_artists') do
    before(:each) do
      Artist.clear
    end
    it("returns a list with every artist that performs on this stage") do
      artist1 = Artist.new("Artist 1", 0)
      artist2 = Artist.new("Artist 2", 0)
      artist3 = Artist.new("Aritst 3", 1)
      expect(@stage_1.get_artists).to(eq([artist1, artist2]))
    end
  end

end
