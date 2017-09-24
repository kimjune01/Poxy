require 'rails_helper'

RSpec.describe SignupController, type: :request do

  describe 'Sign up a user' do

    headers = {
        "Accept" => "application/json",
        "Content-Type" => "application/json"
    }

    it "signs up a user with proper email and password" do


      post "/signup", params: {
          email: "fakeemail@email.com",
          password: "ABCDEFG",
          password_confirmation: "ABCDEFG"
      }.to_json, headers: headers
      expect(response.content_type).to eq("application/json")
      expect(response).to have_http_status(:ok)
    end

    it 'sign up should fail with invalid password and password confiramtion' do
      post "/signup", params: {
          email: "fakeemail@email.com",
          password: "ABCD1errorG",
          password_confirmation: "ABCDEFG"
      }.to_json, headers: headers
      expect(response.content_type).to eq("application/json")
      expect(response).to have_http_status(422)

    end

  end
end
