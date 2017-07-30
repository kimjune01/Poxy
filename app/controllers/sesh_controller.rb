class SeshController < Devise::SessionsController
  protect_from_forgery except: :create


  # POST /login
  def create
    puts "YOU MUST CONSTRUCT MORE PYLONS"
    puts params
    # permitted = params.require(:login).permit([:email, :password])
    permitted = params.require(:sesh).permit([:email, :password])
    input_email = permitted[:email]
    input_password = permitted[:password]
    user = User.find_for_authentication(email: input_email)

    puts(user)
    puts "YOU MUST CONSTRUCT MORE PYLONS"

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
