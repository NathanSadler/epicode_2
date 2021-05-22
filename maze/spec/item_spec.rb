require('rspec')
require('item')
require('obstacle')

describe '#Item' do
  before(:each) do
    Item.clear
    Obstacle.clear
    @item = Item.new("Basic Item")
    @item2 = Item.new("Complex Item")
    @item3 = Item.new("Very Complex Item")
  end

  after(:each) do
    Item.clear
  end

  describe('.all_items') do
    it('returns a list of all items') do
      expect(Item.all_items).to(eq([@item, @item2, @item3]))
    end
  end

  describe('.all_collectible_items') do
    it('returns a list of all collectible items') do
      test_interactable = InteractableItem.new("foo", [])
      expect(Item.all_collectible_items).to(eq([@item, @item2, @item3]))
    end
  end

  describe('#delete') do
    it('deletes itself') do
      @item3.delete
      expect(Item.all_items).to(eq([@item, @item2]))
    end
  end
end

describe '#InteractableItem' do
  before(:all) do
    @obstacle_a = OtherObstacle.new("foo", true)
    @obstacle_b = OtherObstacle.new("bar", false)
    @interactable = InteractableItem.new("lever", [@obstacle_a, @obstacle_b])
  end
  describe('#change_obstacle_states') do
    it('changes the state of each obstacle it is linked to') do
      @interactable.change_obstacle_states
      expect(@obstacle_a.can_pass?).to(eq(false))
      expect(@obstacle_b.can_pass?).to(eq(true))
    end
  end
  describe('.all_interactable_items') do
    it('returns a list of every interactable item') do
      test_collectible = Item.new("Basic Item")
      expect(InteractableItem.all_interactable_items).to(eq([@interactable]))
    end
  end
end
