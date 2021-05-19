require('rspec')
require('meter')

describe '#Meter' do
  before(:each) do
    @tam_meter = Meter.new
  end

  describe('#set_level') do
    it("can set its level to a given value") do
      @tam_meter.set_level(1)
      expect(@tam_meter.level).to(eq(1))
    end
    it("sets the level to the minimum if a value lower than the minimum is" +
      " given") do
      @tam_meter.set_level(-1)
      expect(@tam_meter.level).to(eq(0))
    end
    it("sets the level to the maximum if a value greater than the maximum is" +
    "given") do
      @tam_meter.set_level(11)
      expect(@tam_meter.level).to(eq(10))
    end
  end

  describe('#increase') do
    it("increases the meter's level") do
      @tam_meter.increase
      expect(@tam_meter.level).to(eq(10))
    end
  end

  describe('#decrease') do
    it("decreases the meter's level") do
      @tam_meter.decrease
      expect(@tam_meter.level).to(eq(8))
    end
  end
end
