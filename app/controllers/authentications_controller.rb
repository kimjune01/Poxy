class AuthenticationsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create, :update, :auth] #for dev only, disables authenticity checking on create/update

  def thoushaltnotbenamed

    goodFields = [:user_id, :session_token]
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

  def auth

    goodFields = [:user_id, :session_token]

    puts params
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
    begin
      params.permit(goodFields)
      params.require(goodFields)
    rescue ActionController::ParameterMissing
      return render :json => {:reason => "missing JSON field"}, :status => 422
    rescue ActionController::UnpermittedParameters
      return render :json => {:reason => "extraneous JSON fields"}, :status => 422
    end

    if sessionValid?
      # render something
      payload = {
          authenticated: true
      }
      render :json => payload, :status => 200
    else
      payload = {
          error: "Invalid authentication credentials"   }
    puts "====================================================="
      render :json => payload, :status => :bad_request
    end

  end

  def randomToken
    o = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten
    token = (0...31).map {o[rand(o.length)]}.join
    return token
  end

  def sessionValid?()
    token = params[:session_token]
    user_id = params[:user_id]
    user = User.find_by_id(user_id)
    if user
      return user.session_token == token
    end

    return false
  end

end
