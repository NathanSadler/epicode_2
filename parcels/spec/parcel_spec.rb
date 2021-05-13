require('parcel')
require('rspec')

describe '#Parcel' do

  before(:each) do
    @parcel_a = Parcel.new(2, 3, 4, 5)
    @parcel_b = Parcel.new(3, 3, 3, 6)
    @parcel_a.save
    @parcel_b.save
  end

  after(:each) do
    Parcel.clear
  end

  describe('#==') do
    it('is true if they have the same instance variables') do
      foo = @parcel_a
      expect(foo == @parcel_a).to(eq(true))
    end

    it("is false if they don't have the same instance variable") do
      expect(@parcel_a == @parcel_b).to(eq(false))
    end
  end

  describe(".clear") do
    it("Removes all parcels from the mock database") do
      Parcel.clear
      expect(Parcel.all).to(eq([]))
    end
  end

  describe('.save') do
    it("saves a parcel to the mock database") do
      new_parcel = Parcel.new(1, 2, 3, 4, 5)
      new_parcel.save
      expect(Parcel.all.include?(new_parcel)).to(eq(true))
    end
  end

  describe(".all") do
    it("Returns a list of every parcel") do
      expect(Parcel.all).to(eq([@parcel_a, @parcel_b]))
    end
  end

  describe('#update') do
    before(:each) do
      @parcel_a.update(2, 3, 4, 6)
    end

    it("Updates itself") do
      expect(@parcel_a.weight).to(eq(6))
    end

    it("doesn't change anything in the database") do
      expect(Parcel.all.include?(@parcel_a)).to(eq(false))
    end
  end

  describe('#delete') do
    it("removes itself from the database") do
      @parcel_a.delete
      expect(Parcel.all).to(eq([@parcel_b]))
    end
  end

  describe('.find') do
    it("returns a parcel with a specified ID") do
      expect(Parcel.find(1)).to(eq(@parcel_a))
    end
  end

  describe('#volume') do
    it("returns the parcel's volume") do
      expect(@parcel_a.volume).to(eq(24))
    end
  end

  describe('#cost_to_ship') do
    it("returns the cost of shipping this parcel") do
      parcel_c = Parcel.new(2, 2, 2, 26)
      expect(parcel_c.cost_to_ship).to(eq(5))
    end
  end
end
