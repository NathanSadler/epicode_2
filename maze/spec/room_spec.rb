require('rspec')
require('room')
require('path')
require('obstacle')

describe '#Room' do
  before(:each) do
    Room.clear
    Obstacle.clear
    Path.clear
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

  describe('#name') do
    it("returns the name of the room") do
      temp_room = Room.new(items={}, name="Test Room")
      expect(temp_room.name).to(eq("Test Room"))
    end
    it("returns 'Room\# id' if the room's name is the same as its ID") do
      expect(@room0.name).to(eq('Room #0'))
    end
  end

  describe('#restore_items') do
    it("adds all items ever added to the room back") do
      Item.clear
      item_a = Item.new("test item 1")
      item_b = Item.new("test item 2")
      test_room = Room.new({item_a.id => item_a})
      test_room.add_item(item_b)
      test_room.items.delete(item_a.id)
      test_room.restore_items
      expect(test_room.items).to(eq({item_a.id => item_a, item_b.id => item_b}))
    end
  end

end
