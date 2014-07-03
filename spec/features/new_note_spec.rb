require 'spec_helper.rb'

feature "Creating a new note", js: true do
  scenario "Clicking on new note link" do
    visit '/'
    click_on "New Note"
    expect(page).to have_content("Create a New Note")
  end

  scenario "Clicking Save button" do
    visit '/'
    click_on "New Note"
    fill_in "kanji", with: "今年"
    fill_in "kana", with: "ことし"
    fill_in "meaning", with: "This year"
    click_on "Save"

    expect(page).to have_content("今年")
    expect(page).to have_content("This year")
  end
end
