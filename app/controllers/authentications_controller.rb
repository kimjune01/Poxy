class AuthenticationsController < ApplicationController
  
  def thoushaltnotbenamed
    
    goodFields = [:userID, :session_token]
    begin
      params.require(goodFields) 
    rescue 
      render :nothing => true, :status => 422
    end
    isPermitted = params.permit(goodFields).permitted?

    if !isPermitted
      render :json => {:reason => "bad params"}, :status => 422
    end
    if sessionValid?
    # render something
      payload = {
        authenticated: true
      }
      render :json => payload, :status => 200
    else
      payload = {
        error: "No such user; check the submitted email address",
      }
      render :json => payload, :status => :bad_request
  end
    
  end
  
  def randomToken
    o = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten
    token = (0...31).map { o[rand(o.length)] }.join
    return token
  end
  
  def sessionValid?()
    token = params[:session_token]
    userID = params[:userID]
    user = User.find_by_id(userID)
    if user 
      return user.session_token == token
    end
    
    return false
  end
  
end
