require 'spec_helper.rb'

feature 'listing notes', js: true do
  scenario 'clicking on all notes' do
    visit '/'
    click_on 'List'
    click_on 'All Notes'
    expect(page).to have_content('All Notes')
  end
end
