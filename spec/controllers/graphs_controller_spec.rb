require 'spec_helper'
describe GraphsController do
  render_views
  describe 'index' do
    before do
      xhr :get, :social, format: :json
    end

    subject(:results) { response.body }

    context 'testing with dummy data' do
      json = File.read(Rails.root.join('spec/fixtures/clusters.json'))
      json = json.gsub("\n","")

      let(:network) { json }

      it 'should 200' do
        expect(response.status).to eq(200)
      end

      it 'assigns the json network' do
        expect(results).to eq(network)
      end
    end
  end
end
