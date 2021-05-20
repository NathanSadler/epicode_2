require('rspec')
require('player')
require('item')
require('room')

describe '#Player' do
  before(:each) do
    Player.clear
    Room.clear
    @test_player = Player.new
    @test_room = Room.new
    @test_room_2 = Room.new
  end

  describe('#current_room') do
    it("gets the room object with the ID of the player's current_room_id") do
      room = @test_player.current_room
      expect(room).to(eq(@test_room))
    end
  end

  describe('#move_to_room') do
    it("moves the current player to the room that has the given id") do
      @test_player.move_to_room(1)
      expect(Player.current_player.current_room).to(eq(@test_room_2))
    end
    it("doesn't move the player if there is no room with the given room id") do
      @test_player.move_to_room(0)
      @test_player.move_to_room(999)
      expect(Player.current_player.current_room).to(eq(@test_room))
    end
  end
  describe('#add_to_inventory') do
    it("adds a given item to the player's inventory") do
      key = Item.new("key")
      @test_player.add_to_inventory(key)
      expect(Player.current_player.inventory).to(eq([key]))
    end
  end
end
