require('capybara/rspec')
require('./app')
require('room')
require('path')
require('item')
require('obstacle')
Capybara.app = Sinatra::Application
set(:show_exceptions, false)

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
