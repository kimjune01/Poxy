class AuthenticationsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create, :update, :auth] #for dev only, disables authenticity checking on create/update

  #POST /authenticate
  def auth
    params.require(:authentication).permit([:user_id, :session_token])
    if sessionValid?
      head :ok
    else
      render :json => {error: "Invalid authentication credentials"}, :status => :bad_request
    end
  end

  def sessionValid?
    token = params[:session_token]
    user_id = params[:user_id]
    user = User.find_by_id(user_id)
    if user
      return user.session_token == token
    end
    return false
  end

end
