require('board')
require('rspec')
require('message')
require('time')
require('pry')

describe '#Message' do
  before(:each) do
    Board.clear
    Message.clear
  end

  after(:each) do
    Board.clear
    Message.clear
  end
  describe('#get_board') do
    it('gets the board it belongs to') do
      foo = Board.new("foo")
      foo.save
      bar = Message.new("bar", 0, "")
      bar.save
      expect(bar.get_board).to(eq(foo))
    end
  end

  describe('.get_messages_in_board') do
    it('gets every message in a given board') do
      boarda= Board.new("boarda")
      boardb = Board.new("boardb")
      messagea = Message.new("a", 0, "")
      messageb = Message.new("b", 1, "")
      messagec = Message.new("c", 0, "")
      [boarda, boardb, messagea, messageb, messagec].each do |i|
        i.save
      end
      expect(Message.get_messages_in_board(0)).to(eq([messagea, messagec]))
    end
  end
end
