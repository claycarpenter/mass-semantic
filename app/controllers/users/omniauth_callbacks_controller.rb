class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    logger.debug "request.env inspect: #{request.env["omniauth.auth"].inspect}"

    @user = User.from_omniauth(request.env["omniauth.auth"])
    logger.debug "ctrl user inspect #{@user.inspect}"

    logger.debug "user new_record? #{@user.new_record?}, persisted? #{@user.persisted?}"

    if @user.persisted?
      sign_in_and_redirect @user
    else
      logger.debug "New user URL: #{new_user_registration_url}"
      session["devise.github_data"] = request.env["omniauth.auth"]

      # TODO: Should this be a redirect or render?
      redirect_to new_user_registration_url
    end
  end

  # More info at:
  # https://github.com/plataformatec/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end
end
