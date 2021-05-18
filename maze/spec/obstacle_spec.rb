require('rspec')
require('obstacle')
require('room')

describe '#Obstacle' do
  describe('.get_blocked_paths') do
    it('returns a hash detailing the paths that have obstacles') do
      # Something here later
    end
  end
end

describe '#ItemObstacle' do
  before(:each) do
    @item_obstacle = ItemObstacle.new(:test_obstacle, :key)
  end

  describe('#can_pass?') do
    it('Is false if the required item is not in the inventory') do
      expect(@item_obstacle.can_pass?([:rope, :candle])).to(eq(false))
    end
    it('is true if the required item is in the inventory') do
      expect(@item_obstacle.can_pass?([:candle, :key])).to(eq(true))
    end
  end
end

describe '#OtherObstacle' do
  before(:each) do
    @other_obstacle = OtherObstacle.new(:other_obstacle)
    @other_obstacle2 = OtherObstacle.new(:another_obstacle, true)
  end
  describe('#switch_state') do
    it("reverses the state of the obstacle") do
      expect(@other_obstacle.switch_state).to(eq(true))
      expect(@other_obstacle2.switch_state).to(eq(false))
    end
    it("updates itself in obstacle_list") do
      @other_obstacle.switch_state
      expect(OtherObstacle.get_obstacle_by_name(@other_obstacle.name).can_pass?).to(eq(true))
    end
  end
  describe('#can_pass?') do
    it("returns the current state of the obstacle") do
      expect(@other_obstacle.can_pass?).to(eq(false))
      expect(@other_obstacle2.can_pass?).to(eq(true))
    end
  end
end
