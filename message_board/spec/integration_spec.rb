require('capybara/rspec')
require('./app')
require('message')
require('board')
Capybara.app = Sinatra::Application
set(:show_exceptions, false)
enable :sessions


describe('create a board', {:type => :feature}) do
  it('lets users create a new board') do
    visit('/')
    click_on('Create new board')
    fill_in('board_name', :with => "Foo Board")
    click_on('Submit')
    expect(page).to have_content("Foo Board")
  end
end

describe('login', {:type => :feature}) do
  it('lets users log in as an admin') do
    visit('/')
    click_on('Login as admin')
    expect(page).to have_content("Logout")

  end
end
