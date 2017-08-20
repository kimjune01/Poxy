require 'rails_helper'

RSpec.describe ParksController, type: :request do


  describe "GET #nearby" do
    it "returns http success" do
      get '/parks/nearby/?latitude=6.4238&longitude=66.5897'
      expect(response).to have_http_status(:success)
    end

    it 'returns http bad response' do
      get '/parks/nearby/' do
        expect(response).to have_http_status(422)
      end
    end

  end
end
