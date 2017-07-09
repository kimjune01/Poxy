class RegistrationsController < Devise::RegistrationsController
  skip_before_action :verify_authenticity_token, only: [:create, :update] #for dev only, disables authenticity checking on create/update


  def create

    input_email = params[:email]
    input_password = params[:password]
    confirm_password = params[:password_confirmation]

    newUser = User.new(email:input_email, password:input_password, password_confirmation:confirm_password)

    #Successful Registration
    if newUser.save
      #Generate a token, then send it back.
      newUser.update(session_token:randomToken)

      payload = {
          user_id:newUser.id,
          token:newUser.session_token
      }

      render :json => payload, :status => 200
    else
      return render :json => {:reason => "Unable to create user"}, :status => 409
    end

  end


  def randomToken
    o = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten
    token = (0...31).map {o[rand(o.length)]}.join
    return token
  end

end