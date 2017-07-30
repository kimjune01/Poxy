class SessionsController < Devise::SessionsController
  protect_from_forgery except: :create


  # POST /login
  def create
    puts params
    params.require(:login).permit([:email, :password])
    input_email = params[:email]
    input_password = params[:password]

    user = User.find_for_authentication(email: input_email)

    if user.valid_password?(input_password)
      payload = {
          user_id: user.id,
          token: user.session_token
      }
      render :json => payload, :status => 200
    else
      render :json => {:reason => "Invalid credentials"}, :status => 409
    end


  end

end
