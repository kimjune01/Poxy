class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  protect_from_forgery with: :null_session, only: Proc.new { |c| c.request.format.json? }
  rescue_from ActionController::ParameterMissing, :with => :missing_params
  rescue_from ActionController::UnpermittedParameters, :with => :unpermitted_params

  def missing_params
    render :json => {:reason => "missing JSON field"}, :status => 422
  end

  def unpermitted_params
    render :json => {:reason => "extraneous JSON fields"}, :status => 422
  end



end
