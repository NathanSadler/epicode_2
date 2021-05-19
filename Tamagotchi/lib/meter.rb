class Meter

  attr_reader :level, :min, :max

  def initialize(starting_value = 9, min = 0, max = 10)
    @level = starting_value
    @min = min
    @max = max
  end

  def increase(value=1)
    set_level(@level + value)
  end

  def decrease(value=1)
    set_level(@level - value)
  end

  def set_level(value)
    if value < @min
      @level = @min
    elsif value > @max
      @level = @max
    else
      @level = value
    end
  end

end
