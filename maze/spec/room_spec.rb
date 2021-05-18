require('rspec')
require('room')
require('path')
require('obstacle')

describe '#Room' do
  before(:each) do
    @room0 = Room.new
    @room1 = Room.new
    @room2 = Room.new
    @obstacle = OtherObstacle.new("foo", false, "Block text", "Pass Text")
    @path0 = Path.new(@room0, :north, @room1, :south)
    @path1 = Path.new(@room0, :west, @room2, :east, @obstacle)
  end

  describe('#use_path') do
    it("travels along a path to another room") do
      expect(@room0.use_path(:north)).to(eq(@room1))
    end
    it("returns the block text of the obstacle if there is one blocking the way") do
      expect(@room0.use_path(:west)).to(eq("Block text"))
    end
    it("returns nil if there is not a path in the specified direction") do
      expect(@room0.use_path(:east)).to(eq(nil))
    end
  end

end
