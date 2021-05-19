class Tamagotchi
  attr_reader :name, :happiness, :food, :energy

  @@current_tamagotchi = nil

  def initialize(name)
    @name = name
    @happiness = Meter.new
    @food = Meter.new
    @energy = Meter.new
    @@current_tamagotchi = self
  end

  # Returns true if food level is > 0
  def is_alive?
    @food.level > 0
  end

  # Updates the version of itself in current_tamagotchi
  def update
    @@current_tamagotchi = self
  end

  # Increases the level of the meter associated with action by 1. Decreases
  # all other meters by 1
  def spend_time(action)
    @happiness.decrease
    @food.decrease
    @energy.decrease
    case action
    when :play
      @happiness.increase(2)
    when :eat
      @food.increase(2)
    when :sleep
      @energy.increase(2)
    end
    update
  end

  def self.current_tamagotchi
    return @@current_tamagotchi
  end

end
