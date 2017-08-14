require 'rails_helper'

RSpec.describe ParksController, type: :controller do

  describe "GET #nearby" do
    it "returns http success" do
      get :nearby
      expect(response).to have_http_status(:success)
    end
  end

end
