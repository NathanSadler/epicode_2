require('capybara/rspec')
require('./app')
require('room')
require('path')
require('player')
require('item')
require('obstacle')
Capybara.app = Sinatra::Application
set(:show_exceptions, false)


describe('looking around', {:type => :feature}) do
  before(:each) do
    visit('/')
    click_on('Play Maze')
    click_on('Start game with default maze')
  end

  it('lists the pathways in the current room') do
    click_on('Look Around')
    expect(page).to have_content("There is a pathway heading north.")
    expect(page).to have_content("There is a pathway heading east.")
  end

  it("doesn't list pathways that aren't there") do
    click_on('Look Around')
    expect(page).to have_no_content("There is a pathway heading south.")
  end

  it("lists obstacles if there are any") do
    click_on('Go north')
    click_on('Look Around')
    expect(page).to have_content("It is blocked by a locked door.")
  end

  it("lets users pick up items") do
    click_on('Go east')
    click_on('Go south')
    click_on('Go south')
    click_on('Look Around')
    expect(page).to have_content("There is a key")
    click_on('Pick Up')
  end

  it("doesn't display items that have already been picked up") do
    Player.current_player.move_to_room(4)
    visit('/game')
    click_on('Look Around')
    click_on('Pick Up')
    click_on('Look Around')
    expect(page).to have_no_content("There is a key")
  end
  it("doesn't mention obstacles that the player already used an item to " +
  "pass") do
    Player.current_player.move_to_room(4)
    visit('/game')
    click_on('Look Around')
    click_on('Pick Up')
    Player.current_player.move_to_room(1)
    visit('/game')
    click_on('Go north')
    click_on('Look Around')
    expect(page).to have_no_content("It is blocked by a locked door.")
  end
end



describe('create a room', {:type => :feature}) do
  it('creates a room and goes to the rooms menu') do
    visit('/')
    click_on('Maze Editor')
    click_on('Rooms')
    click_on('Add a room')
    fill_in('room_name', :with => "foo")
    click_on('Submit')
    expect(page).to have_content("All Rooms")
    expect(page).to have_content("foo")
  end
end

describe('create a path', {:type => :feature}) do
  before(:all) do
    Path.clear
    Item.clear
    Obstacle.clear
  end
  it('creates a path and goes to the paths menu') do
    visit('/')
    Room.new({}, "bar")
    click_on('Maze Editor')
    click_on('Paths')
    click_on('Add a path')

    select 'foo', from: 'First Room'
    select 'north', from: 'First Room direction'
    select 'bar', from: 'Second Room'
    select 'south', from: 'Second Room direction'
    click_on('Submit')
    expect(page).to have_content("Path from foo to bar")
  end
end
