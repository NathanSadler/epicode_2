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
    expect(page).to have_content("Skeleton Key")
    # make sure it goes to the read page
    expect(page).to have_content("Back")
    expect(page).to have_content("Edit")
  end
  it('creates an interactable item') do
    visit('/editor/item/create')
    click_on('Interactable Item')
    fill_in('item_name', :with => "Skeleton Lever")
    check('large gap')
    # Make sure obstacles that shouldn't be there aren't there
    expect(page).to have_no_content("locked door")

    click_on("Submit")

    # Make sure selected obstacle displays appropriately
    expect(page).to have_content("large gap")
    expect(page).to have_content("Skeleton Lever")
  end
  it('updates items') do
    visit('/editor/item')
    click_on("Skeleton Lever")
    click_on('Edit')
    fill_in('item_name', :with => "Rod of activation")
    click_on('Submit')
    expect(page).to have_content("Rod of activation")
  end
  it('deletes items') do
    visit('/editor/item')
    click_on("Rod of activation")
    click_on("Edit")
    click_on("Delete")
    expect(page).to have_no_content("Rod of activation")
    expect(page).to have_content("Items")
  end
end

describe('Obstacle CRUD', {:type => :feature}) do
  before(:all) do
    visit('/')
    click_on('Maze Editor')
    click_on('Reset Maze to Default')
    click_on('Obstacles')
  end
  after(:all) do
    Item.clear
    Obstacle.clear
    Room.clear
    Path.clear
  end
  it('creates an item obstacle') do
    click_on('Add a obstacle')
    click_on('Item Obstacle')
    fill_in('obstacle_name', :with => "Test Item Obstacle")
    fill_in('block_text', :with => "Test Block Text")
    fill_in('pass_text', :with => "Test Pass Text")
    click_on('Submit')
    expect(page).to have_content("Test Item Obstacle")
  end
  it('creates an environmental obstacle') do
    visit('/editor/obstacle/create')
    click_on('Environmental Obstacle')
    fill_in('obstacle_name', :with => "Test Environmental Obstacle")
    fill_in('block_text', :with => "Test Block Text")
    fill_in('pass_text', :with => "Test Pass Text")
    click_on('Submit')
    expect(page).to have_content("Test Environmental Obstacle")
  end
  it('reads obstacles') do
    visit('/editor/obstacle')
    click_on("Test Item Obstacle")
    expect(page).to have_content("Test Item Obstacle")
    expect(page).to have_content("Test Block Text")
    expect(page).to have_content("Required Item: key")
  end
  it('updates item obstacles') do
    Item.new("Skeleton Key")
    visit('/editor/obstacle')
    click_on("Test Item Obstacle")
    click_on("Edit")
    fill_in('obstacle_name', :with => "Updated Test Item Obstacle")
    fill_in('block_text', :with => "Updated Test Block Text")
    fill_in('pass_text', :with => "Updated Test Pass Text")
    select 'Skeleton Key', from: "Item required to pass"
    click_on('Submit')
    expect(page).to have_content("Updated Test Item Obstacle")
    expect(page).to have_content("Updated Test Block Text")
    expect(page).to have_content("Required Item: Skeleton Key")
  end
  it('updates environmental obstacles') do
    visit('/editor/obstacle')
    click_on("Test Environmental Obstacle")
    click_on("Edit")
    #save_and_open_page
    fill_in('obstacle_name', :with => "Updated Test Environmental Obstacle")
    fill_in('block_text', :with => "Updated Test Block Text")
    fill_in('pass_text', :with => "Updated Test Pass Text")
    select 'Yes', from: 'Clearable by default?'
    click_on('Submit')
    expect(page).to have_content("Updated Test Environmental Obstacle")
    expect(page).to have_content("Updated Test Block Text")
    expect(page).to have_content("Clearable by default: true")
  end
  it("doesn't create duplicate obstacles when updating") do
    visit('/editor/obstacle')
    expect(page).to have_content("Updated Test Environmental Obstacle", count: 1)
    expect(page).to have_content("Updated Test Item Obstacle", count: 1)
  end
  it("deletes obstacles") do
    temp_obs = OtherObstacle.new("to be deleted")
    visit('/editor/obstacle')
    click_on("to be deleted")
    click_on("Edit")
    click_on("Delete")
    expect(page).to have_no_content("to be deleted")
    expect(page).to have_content("Obstacles")
  end
end

describe("creating and playing a custom maze", {:type => :feature}) do
  before(:all) do
    visit('/editor')
    click_on('Reset Maze to Default')
    #pwall = OtherObstacle.new("Pointless Wall", true,
    #"You are blocked by a pointless wall",
    #"You are not blocked by a pointless wall")
  end
  it('creates the maze') do
    # Create the obstacle
    visit('/editor/obstacle')
    click_on('Add a obstacle')
    click_on('Environmental Obstacle')
    fill_in 'obstacle_name', :with => "pwall"
    fill_in 'block_text', :with => "blocked by pwall"
    fill_in 'pass_text', :with => "not blocked by pwall"
    select 'Yes', from: "Clearable by default?"
    click_on('Submit')
    expect(page).to have_content("Clearable by default: true")
    expect(page).to have_content("Obstacle Name: pwall")

    # Create the InteractableItem
    visit('/editor/item')
    click_on('Add a item')
    click_on('Interactable Item')
    fill_in('item_name', :with => "plever")
    fill_in('interaction_text', :with => "flick lever")
    check('pwall')
    click_on('Submit')
    expect(page).to have_content("Interaction Text: flick lever")
    expect(page).to have_content("Linked Obstacle: pwall")

    # Create the room
    visit('/editor/room')
    click_on('Add a room')
    fill_in('room_name', :with => "proom")
    choose('Neither')
    check('plever')
    click_on('Submit')
    click_on('proom')
    expect(page).to have_content('Details for proom')
    expect(page).to have_content('Items in this room')
    expect(page).to have_content('plever')

    # Create path between room 2 and new room
    visit('/editor/path')
    click_on('Add a path')
    select 'Room #2', from: 'First Room'
    select 'north', from: 'First Room direction'
    select 'proom', from: 'Second Room'
    select 'south', from: 'Second Room direction'
    click_on('Submit')
    click_on('Path from Room #2 to proom')
    expect(page).to have_content('First Room: Room #2')
    expect(page).to have_content('Second Room: proom')
    expect(page).to have_content('First Room Direction: north')
    expect(page).to have_content('Second Room Direction: south')
    click_on('Back')

    # Create path between rooom 1 and new room
    click_on('Add a path')
    select 'Room #1', from: 'First Room'
    select 'east', from: 'First Room direction'
    select 'proom', from: 'Second Room'
    select 'west', from: 'Second Room direction'
    select 'pwall', from: 'Obstacle'
    click_on('Submit')
    click_on('Path from Room #1 to proom')
    expect(page).to have_content('First Room: Room #1')
    expect(page).to have_content('Second Room: proom')
    expect(page).to have_content('First Room Direction: east')
    expect(page).to have_content('Second Room Direction: west')
    expect(page).to have_content('Obstacle: pwall')
  end
  it('plays the maze') do
    visit('/game/menu')
    click_on('Start game with current maze')
    click_on('Go east')
    click_on('Go south')
    click_on('Go south')
    click_on('Look Around')
    click_on('Pick Up')
    click_on('Go north')
    click_on('Go north')
    click_on('Go north')
    expect(page).to have_content("proom")
    click_on('Look Around')
    click_on('flick lever')
    click_on('Go west')
    click_on('OK')
    click_on('Look Around')
    click_on('flick lever')
    click_on('Go west')
    click_on('Go north')
    click_on('Look Around')
    click_on('Flick Lever')
    Player.current_player.move_to_room(2)
    visit('/game')
    click_on('Go east')
  end
  it('can reset the maze before replaying') do
    visit('/game/menu')
    click_on('Start game with current maze')
    Player.current_player.move_to_room(4)
    visit('/game')
    click_on('Look Around')
    expect(page).to have_content('Pick Up')
    Player.current_player.move_to_room(1)
    visit('/game')
    #binding.pry
    click_on('Go north')
    expect(page).to have_content('The door to this path is locked.')
    Player.current_player.move_to_room(2)
    visit('/game')
    click_on('Go east')
    expect(page).to have_content('A large gap prevents you from passing.')
  end

end
