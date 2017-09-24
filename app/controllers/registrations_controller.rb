class RegistrationsController < Devise::RegistrationsController
  skip_before_action :verify_authenticity_token, only: [:create, :update] #for dev only, disables authenticity checking on create/update

  # POST /users
  def create
    puts params
    params.require(:registration).permit([:email, :password, :password_confirmation])

    input_email = params[:email]
    input_password = params[:password]
    confirm_password = params[:password_confirmation]

    newUser = User.new(email: input_email, password: input_password, password_confirmation: confirm_password, session_token: randomToken)

    #Successful Registration
    if newUser.save
      #Generate a token, then send it back.
      payload = {
          user_id: newUser.id,
          session_token: newUser.session_token
      }
      render :json => payload, :status => 200
    else
      render :json => {:reason => "Unable to create user"}, :status => 409
    end

  end


  def randomToken
    o = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten
    token = (0...31).map {o[rand(o.length)]}.join
    return token
  end

end
