require('capybara/rspec')
require('./app')
Capybara.app = Sinatra::Application
set(:show_exceptions, false)

describe('create a stage path', {:type => :feature}) do
  it('Creates a stage and goes to its stage page') do
    visit('/')
    click_on('Add a new stage')
    fill_in('stage_name', :with => 'Great Deku Tree')
    click_on('Submit')
    expect(page).to have_content('Stage name: Great Deku Tree')
  end
  it('Adds the stage to the list of stages on the main page') do
    visit('/')
    expect(page).to have_content('Great Deku Tree')
  end
end

describe('edit stage', {:type => :feature}) do
  it('lets users edit the name of the stage') do
    visit('/stage/0/edit')
    fill_in('stage_name', :with => 'Greater Deku Tree')
    click_on('Submit')
    expect(page).to have_content('Stage name: Greater Deku Tree')
  end
end

describe('create an artist path', {:type => :feature}) do
  it('Creates an artist and goes to its info page') do
    visit('/')
    click_on('Add a new artist')
    fill_in('artist_name', :with => "Hetsu")
    select 'Greater Deku Tree', from: 'Stage'
    click_on('Submit')
    expect(page).to have_content('Artist name: Hetsu')
  end
end
