require 'spec_helper'

describe NotesController do
  render_views
  describe 'index' do
    before do
      Note.create!(kanji: "去年", kana: 'きょねん', meaning: 'Last year')
      Note.create!(kanji: "今年 去年", kana: 'ことし', meaning: 'This year, last year')

      xhr :get, :index, format: :json, keywords: keywords
    end

    subject(:results) { JSON.parse(response.body) }

    def extract_kanji
      ->(object) { object['kanji'] }
    end

    context 'when the search find results' do
      let(:keywords) { "去年" }

      it 'should 200' do
        expect(response.status).to eq(200)
      end

      it 'should return two results' do
        expect(results.size).to eq(2)
      end

      it "should include '去年 - last year'" do
        expect(results.map(&extract_kanji)).to include("去年")
      end

      it "should include '今年 去年 - this year, last year'" do
        expect(results.map(&extract_kanji)).to include("今年 去年")
      end

    end

    context "when the search doesn't find results" do
      let(:keywords) { 'foo' }
      it 'should return no results' do
        expect(results.size).to eq(0)
      end
    end
  end


end
