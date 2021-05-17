require('capybara/rspec')
require('./app')
require('stage')
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
  it('Adds the artist to the list of artists on the main page') do
    visit('/')
    expect(page).to have_content('Hetsu')
  end
end

describe('edit artist', {:type => :feature}) do
  it('Lets users change the name of the artist') do
    visit('/artist/0/edit')
    fill_in('artist_name', :with => "Generic Korok")
    click_on('Submit')
    expect(page).to have_content('Artist name: Generic Korok')
    expect(page).to have_content('Stage: Greater Deku Tree')
  end
  it('Lets users change the stage the artist performs on') do
    Stage.new("Under some rock")
    visit('/artist/0/edit')
    select 'Under some rock', from: 'Stage'
    click_on('Submit')
    expect(page).to have_content("Stage: Under some rock")
  end
end

describe('delete artist', {:type => :feature}) do
  it('Lets users delete an artist') do
    visit('/artist/0/edit')
    click_on('Delete Artist')
    expect(page).to have_content('There are no artists')
  end
end

describe('delete stage', {:type => :feature}) do
  it('lets users delete a stage') do
    visit('/stage/0/edit')
    Stage.get_stage_with_id(1).delete
    click_on('Delete Stage')
    expect(page).to have_content('There are no stages')
  end
end
