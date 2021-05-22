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

describe('creating a room', {:type => :feature}) do
  before(:each) do
    visit('/')
    click_on('Maze Editor')
    click_on('Rooms')
  end

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

describe('reading a room', {:type => :feature}) do
  before(:each) do
    visit('/')
    click_on('Play Maze')
    click_on('Start game with default maze')
    visit('/')
    click_on('Maze Editor')
    click_on('Rooms')
  end
  it("lists a room's paths") do
    click_on('Room #1')
    expect(page).to have_content("north: Path from Room #1 to Room #5")
  end
  it("doesn't list paths that aren't there") do
    click_on('Room #1')
    expect(page).to have_no_content("west")
  end
  it("provides a list of items in the room") do
    click_on('Room #4')
    expect(page).to have_content("key")
  end
  it("displays a message saying if it is the starting room, ending room, "+
  "or neither") do
    click_on('Room #4')
    expect(page).to have_content("This room is not the starting or ending room.")
    visit('/editor/room')
    click_on('Room #0')
    expect(page).to have_content("This room is the starting room")
    visit('/editor/room')
    click_on('Room #6')
    expect(page).to have_content("This room is the ending room")
  end
end

describe('updating a room', {:type => :feature}) do
  before(:each) do
    visit('/')
    click_on('Play Maze')
    click_on('Start game with default maze')
    visit('/')
    click_on('Maze Editor')
    click_on('Rooms')
  end
  it('fills in/submits a form and changes the room') do
    click_on('Room #4')
    click_on('Edit Room')
    fill_in 'room_name', with: 'Lucky Number 444'
    choose('Starting Room')
    check('lever')
    uncheck('key')
    click_on('Submit')
    expect(page).to have_content('Lucky Number 444')
    expect(page).to have_content('This room is the starting room')
    expect(page).to have_content('lever')
    expect(page).to have_no_content('key')
  end
end

describe('deleting a room', {:type => :feature}) do
  before(:each) do
    visit('/')
    click_on('Play Maze')
    click_on('Start game with default maze')
    visit('/')
    click_on('Maze Editor')
    click_on('Rooms')
  end
  it('deletes a room') do
    click_on('Room #4')
    click_on('Edit Room')
    click_on('Delete Room')
    expect(page).to have_content('All Rooms')
    expect(page).to have_content('Room #1')
    expect(page).to have_no_content('Room #4')
  end
end

describe('create a path', {:type => :feature}) do
  before(:all) do
    visit('/')
    click_on('Play Maze')
    click_on('Start game with default maze')
    visit('/')
    click_on('Maze Editor')
    click_on('Paths')
  end
  it('creates a path and goes to the paths menu') do
    click_on('Add a path')
    select 'Room #0', from: 'First Room'
    select 'south', from: 'First Room direction'
    select 'Room #3', from: 'Second Room'
    select 'west', from: 'Second Room direction'
    click_on('Submit')
    expect(page).to have_content("Path from Room #0 to Room #3")
  end

  it("updates the paths on the rooms' detail pages") do
    visit('/editor/room/read/3')
    expect(page).to have_content("west: Path from Room #0 to Room #3")
    visit('/editor/room/read/0')
    expect(page).to have_content("south: Path from Room \#0 to Room \#3")
  end
end

describe('update a path', {:type => :feature}) do
  before(:all) do
    visit('/')
    click_on('Play Maze')
    click_on('Start game with default maze')
    visit('/')
    click_on('Maze Editor')
    click_on('Paths')
  end
  it('fills in/submits a form and changes a room ') do
    click_on('Path from Room #0 to Room #1')
    click_on('Edit')
    select 'west', from: 'First Room direction'
    select 'Room #1', from: 'Second Room'
    select 'east', from: 'Second Room direction'
    click_on('Submit')
    expect(page).to have_content('First Room Direction: west')
    expect(page).to have_content('Second Room Direction: east')
  end
  it('updates the paths for the rooms') do
    visit('/editor/room/read/0')
    expect(page).to have_content('west: Path from Room #0 to Room #1')
  end
end

describe('delete a path', {:type => :feature}) do
  before(:all) do
    visit('/')
    click_on('Play Maze')
    click_on('Start game with default maze')
    visit('/')
    click_on('Maze Editor')
    click_on('Paths')
  end
  it('deletes a path') do
    click_on('Path from Room #0 to Room #1')
    click_on('Edit')
    click_on('Delete Room')
    expect(page).to have_no_content('Path from Room #0 to Room #1')
  end
end

describe('Item CRUD', {:type => :feature}) do
  before(:all) do
    visit('/')
    click_on('Play Maze')
    click_on('Start game with default maze')
    visit('/')
    click_on('Maze Editor')
    click_on('Items')
  end
  it('creates a collectible item') do
    click_on('Add a item')
    click_on('Collectible Item')
    fill_in('item_name', :with => "Skeleton Key")
    click_on('Submit')
    # add check for item existence later 
  end
end
