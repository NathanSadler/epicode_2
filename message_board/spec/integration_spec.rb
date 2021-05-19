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
  before(:each) do
    visit('/')
    click_on('Login as admin')
  end
  it('lets users log in as an admin') do
    expect(page).to have_content("Logout")
  end
  it('keeps the user logged in even when they move to a new page') do
    click_on("Foo Board")
    expect(page).to have_content("Logout")
  end
  it('Lets users log out') do
    click_on('Logout')
    expect(page).to have_content("Login as admin")
  end

end

describe('create a post', {:type => :feature}) do
  it('lets users create a post') do
    visit('/')
    click_on('Foo Board')
    click_on('Create new message')
    fill_in('message_title', :with => "Foo post")
    fill_in('message_content', :with => "foo")
    click_on('Submit')
    # Make sure post is on list of current board's posts
    expect(page).to have_content("Foo post")
    # Make sure users can get to a post's page
    click_on('Foo post')
    expect(page).to have_content("Foo post")
    expect(page).to have_content("foo")
  end
end

describe('restrict edit access', {:type => :feature}) do
  before(:each) do
    visit('/')
    expect(page).to have_content("Login as admin")
    click_on("Foo Board")
  end
  it('does not let users edit a post if they are not logged in') do
    click_on("Foo post")
    expect(page).to have_no_content("Edit Message")
  end
  it('prevents users from editing a post if they are not logged in') do
    expect(page).to have_no_content("Edit Board")
  end
end

describe('edit and delete messages', {:type => :feature}) do
  before(:each) do
    visit('/')
    click_on("Login as admin")
    click_on("Foo Board")
  end
  it("lets users edit the title and content of messages") do
    click_on("Foo post")
    click_on("Edit Message")
    fill_in('message_title', :with => "Bar post")
    fill_in('message_content', :with => "bar")
    click_on("Submit")
    # Make sure title is updated on message list
    expect(page).to have_content("Bar post")
    # Make sure content got updated too
    click_on("Bar post")
    expect(page).to have_content("bar")
  end
end
