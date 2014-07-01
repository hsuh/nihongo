require 'spec_helper.rb'

feature "Looking up notes", js: true do
  before do
    Note.create!(kanji: "去年", kana: 'きょねん', meaning: 'Last year')
    Note.create!(kanji: "今年 去年", kana: 'ことし', meaning: 'This year, last year')
    Note.create!(kanji: "Cheese")
  end

  scenario "finding notes" do
    visit '/'
    fill_in 'keywords', with: 'cheese'
    click_on 'search'

    expect(page).to have_content("Cheese")
  end
end
