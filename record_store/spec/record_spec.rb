require 'rspec'
require 'record'


describe '#Record' do

  # Creates and saves records to use before each test
  before(:each) do
    @record = Record.new("Foo Beats", nil)
    @record2 = Record.new("Bar Bars", nil)
    @record.save
    @record2.save
  end

  after(:each) do
    Record.clear
  end

  describe('.all') do
    it("Returns a list of the names of each record in the database") do
      @record.save
      expect(Record.all).to(eq([@record, @record2]))
    end

    it("Returns an empty list if there are no values in the mock database") do
      Record.clear
      expect(Record.all).to(eq([]))
    end
  end

  describe('.find') do
    it("Returns the record from the mock database with the given ID") do
    expect(Record.find(1)).to(eq(@record))
    end
  end

  describe('#update') do
    before(:each) do
      @record.update("Foo's Firey Beats")
    end
    it("Updates its name") do
      expect(@record.name).to(eq("Foo's Firey Beats"))
    end
    it("Doesn't update the mock database before saving") do
      expect(Record.find(1).name).to(eq("Foo Beats"))
    end
  end

  describe('#delete') do
    it("Removes its entry from the database") do
      @record.delete
      expect(Record.all).to(eq([@record2]))
    end
  end

  describe('.clear') do
    it("Empties the mock database") do
      Record.clear
      expect(Record.all).to(eq([]))
    end
  end

end
