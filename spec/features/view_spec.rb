require 'spec_helper.rb'

feature "Viewing a note", js: true do
  before do
    Note.create!(kanji: "去年", kana: 'きょねん', meaning: 'Last year')
    Note.create!(kanji: "今年 去年", kana: 'ことし', meaning: 'This year, last year')
  end

  scenario "view one note" do
    visit '/'
    fill_in "keywords", with: "去年"
    click_on "Search"

    click_on "去年"

    expect(page).to have_content("去年")
    expect(page).to have_content('きょねん')

    click_on "Back"

    expect(page).to     have_content('きょねん')
    expect(page).to     have_content("今年 去年")
    expect(page).to_not have_content('雨の日')
  end
end

