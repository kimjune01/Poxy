class SeshController < Devise::SessionsController
  protect_from_forgery except: :create

  # POST /login
  def create
    permitted = params.require(:sesh).permit([:email, :password])
    user = User.find_for_authentication(email: permitted[:email])
    issueBadgeIfValid(user, permitted[:password])
  end

  def issueBadgeIfValid(user, password)
    if user.valid_password?(password)
      user.session_token = randomToken
      user.save
      render :json => {user_id:user.id, token:user.session_token}, :status => 200
    else
      render :json => {:reason => "Invalid credentials"}, :status => 409
    end
  end

  def randomToken
    o = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten
    token = (0...31).map {o[rand(o.length)]}.join
    return token
  end




end
