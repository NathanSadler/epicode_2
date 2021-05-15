require('capybara/rspec')
require('./app')
Capybara.app = Sinatra::Application
set(:show_exceptions, false)

describe('create an album path', {:type => :feature}) do
  it('creates an album and then goes to the album page') do
    visit('/albums')
    click_on('Add a new album')
    fill_in('album_name', :with => 'Yellow Submarine')
    click_on('Go!')
    expect(page).to have_content('Yellow Submarine')
  end
end

describe('create a song path', {:type => :feature}) do
  it('creates an album and then goes to the album page') do
    album = Album.new("Yellow Submarine", nil)
    album.save
    visit("/albums/#{album.id}")
    fill_in('song_name', :with => 'All You Need Is Love')
    click_on('Add song')
    expect(page).to have_content('All You Need Is Love')
  end
end

describe('move a record from available to sold', {:type => :feature}) do
  it('moves a record from the available section to the sold section') do
    album = Album.new("Yellow Submarine", nil)
    album.save
    visit("/albums/#{album.id}")
    click_on('Buy This Album')
    expect(page.has_content?('There are currently no sold records.')).to(eq(false))
  end
end
