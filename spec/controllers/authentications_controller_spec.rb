require 'rails_helper'

RSpec.describe AuthenticationsController, type: :request do

  describe User do
    let (:user) {User.create(email: "bob@bob.com",             
      session_token: "ABCDEF", 
      password: "thisisapass", 
      password_confirmation: "thisisapass")}

      it "authenticates a valid user" do
        expect(user).not_to be_nil
        headers = {
            "Accept" => "application/json",
            "Content-Type" => "application/json"
        }
        post "/authenticate", params: {
            user_id: user.id, 
            session_token: "ABCDEF"
            }.to_json, headers: headers
        expect(response.content_type).to eq("application/json")
        expect(response).to have_http_status(:ok)
      end
  end


end
