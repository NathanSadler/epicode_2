require('tamagotchi')
require('rspec')

describe(Tamagotchi) do
  describe("#initialize") do
    it("sets the name and life levels of a new Tamagotchi") do
      my_pet = Tamagotchi.new("lil dragon")
      expect(my_pet.name()).to(eq("lil dragon"))
      expect(my_pet.food().level).to(eq(9))
      expect(my_pet.energy().level).to(eq(9))
      expect(my_pet.happiness().level).to(eq(9))
    end
  end

  describe("#is_alive?") do
    it("is alive if the food level is above 0") do
      my_pet = Tamagotchi.new("lil dragon")
      expect(my_pet.is_alive?).to(eq(true))
    end

    it("is dead if the food level is 0") do
      my_pet = Tamagotchi.new("lil dragon")
      my_pet.food.set_level(0)
      expect(my_pet.is_alive?()).to(eq(false))
    end
  end

  describe('#spend_time') do
    before(:all) do
      @my_pet = Tamagotchi.new("lil dragon")
      @my_pet.spend_time(:play)
    end
    it("increases the level of the meter associated with action by one") do
      expect(@my_pet.happiness.level).to(eq(10))
    end
    it("decreases the level of the meters not associated with action by one") do
      expect(@my_pet.energy.level).to(eq(8))
      expect(@my_pet.food.level).to(eq(8))
    end
  end
end
