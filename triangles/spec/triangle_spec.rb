require('rspec')
require('triangle')

describe '#Triangle' do
  describe('#get_type') do
    it("Returns 'equilateral' if all three sides are the same length") do
      foo = Triangle.new(3, 3, 3)
      expect(foo.get_type).to(eq('equilateral'))
    end

    it("Returns 'isoscoles' if only two sides are the same length") do
      expect(Triangle.new(3, 3, 4).get_type).to(eq('isoscoles'))
    end

    it("returns 'scalene' if no sides have the same length") do
      expect(Triangle.new(3, 4, 5).get_type).to(eq('scalene'))
    end

    it("returns 'not a triangle' if the sum of the lengths of any two sides" +
    "is not greater than the length of the third side") do
      expect(Triangle.new(1, 1, 2).get_type).to(eq('not a triangle'))
    end
  end

  describe('#valid_triangle?') do
    it("is true if the sum of the lengths of any two sides is greater than" +
    "the length of the third side") do
      expect(Triangle.new(2, 3, 4).valid_triangle?).to(eq(true))
    end
    it("is false if the sum of the lengths of any two sides is not greater" +
    "than the length of the third side") do
      expect(Triangle.new(1, 1, 2).valid_triangle?).to(eq(false))
    end
  end
end
