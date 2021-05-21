require('board')
require('rspec')
require('time')
require('pry')

describe '#Board' do
  before(:all) do
    @test_board = Board.new("Test Board")
  end

  describe('#save') do
    it('saves new boards to the mock database') do
      @test_board.save
      expect(Board.all).to(eq([@test_board]))
    end

    it('updates entries in database if they had been saved once before') do
      @test_board.name = "Super Test Board"
      @test_board.save
      expect(Board.all).to(eq([@test_board]))
    end
  end

  describe('#set_name') do
    it('changes the name of the board') do
      
    end
  end

  describe('.sort_by_name') do
    it('sorts a list of Boards by their names') do
      test_board_2 = Board.new("zzzzzz")
      test_board_2.save
      test_board_3 = Board.new("foobar")
      test_board_3.save
      expect(Board.sort_by_name).to(eq([test_board_3, @test_board, test_board_2]))
    end
  end

  describe('.sort_by_timestamp') do
    it('sorts a list of boards by their timestamps') do
      Board.clear
      timetest1 = Board.new("noon")
      timetest1.timestamp = DateTime.new(2021, 1, 1, 12, 0, 0)
      timetest1.save
      timetest2 = Board.new("morning")
      timetest2.timestamp = DateTime.new(2021, 1, 1, 1, 0, 0)
      timetest2.save
      timetest3 = Board.new("night")
      timetest3.timestamp = DateTime.new(2021, 1, 1, 20, 0, 0)
      timetest3.save
      expect(Board.sort_by_timestamp).to(eq([timetest2, timetest1, timetest3]))
      Board.clear
    end
  end

end
