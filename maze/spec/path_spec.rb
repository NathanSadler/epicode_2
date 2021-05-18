require('rspec')
require('path')
require('room')
require('obstacle')
require('pry')

describe '#Path' do
  before(:each) do
    Room.clear
    Obstacle.clear
    Path.clear
    @room0 = Room.new
    @room1 = Room.new
    @room2 = Room.new
    @room3 = Room.new
    @obstacle = OtherObstacle.new("foo", false, "Block text", "Pass Text")
    @patha = Path.new(@room0, :north, @room1, :south)
    @pathb = Path.new(@room0, :east, @room2, :west, @obstacle)
  end

  describe('#can_pass?') do
    it('is true if there is no obstacle in the path') do
      expect(@patha.can_pass?).to(eq(true))
    end
    it('is true if there is an obstacle in the path, but it can be passed') do
      @obstacle.switch_state
      expect(@pathb.can_pass?).to(eq(true))
    end
    it('is false if there is an obstacle that cannot be passed in the path') do
      expect(@pathb.can_pass?).to(eq(false))
    end
  end

  describe('#initialize') do
    it('updates the paths of the rooms it connects') do
      expect(@room0.paths).to(eq({:north => @patha, :south => nil,
        :east => @pathb, :west => nil}))
    end
  end

  describe('#travel_from') do
    it('returns the room that is NOT being travelled from') do
      expect(@patha.travel_from(@room0)).to(eq(@room1))
      expect(@patha.travel_from(@room1)).to(eq(@room0))
    end
    it('returns nil if the room being travelled from is not on the path') do
      expect(@patha.travel_from(@room3)).to(eq(nil))
    end
    it('returns block text of obstacle if a valid starting point is '+
    'given, but the path cannot be travelled because of an obstacle') do
      expect(@pathb.travel_from(@room2)).to(eq("Block text"))
    end
  end

end