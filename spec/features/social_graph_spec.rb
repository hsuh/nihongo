require 'spec_helper.rb'

feature "Viewing a social graph", js: true do
  scenario "Viewing social graph" do
    visit '/'
    click_on "Graph"
    click_on "Social"
    expect(page).to have_content("Graph")
  end
end
