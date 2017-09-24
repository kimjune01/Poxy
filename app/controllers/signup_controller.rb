class SignupController < ApplicationController
  skip_before_action :verify_authenticity_token
  #, only: [:create, :update, :auth] #for dev only, disables authenticity checking on create/update

  #POST /signup
  def signup
    puts 'signup is happening here'
    permitted = params.require('signup').permit(['email', 'password', 'password_confirmation'])
    @newUser = User.new(permitted)
    if @newUser.save
      head :ok
    else
      render json:{"reason": "could not create user"}, status: 422
    end
  end

end
