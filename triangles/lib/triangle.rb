class Triangle
  def initialize(a, b, c)
    @a = a
    @b = b
    @c = c
    @lengths = [@a, @b, @c]
  end

  # Returns the type of triangle (equilateral, isoscoles, scalene, or not
  # a triangle)
  def get_type
    if self.valid_triangle?
      case @lengths.uniq.length
      when 1
        'equilateral'
      when 2
        'isoscoles'
      when 3
        'scalene'
      end
    else
      'not a triangle'
    end
  end

  # Returns false if the sum of the length of any two sides is less than or
  # equal to the length of the third side
  def valid_triangle?
    3.times do
      @lengths.push(@lengths.shift)
      if (@lengths[0] + @lengths[1]) <= @lengths[2]
        return false
      end
    end
    true
  end
end
