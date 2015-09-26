class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :log_user, if: :security_debug_log?

  # TODO: Not sure if these two helpers are necessary...
  def new_session_path(scope)
    new_user_session_path
  end

  def session_path(scope)
    user_session_path
  end

  protected

  def configure_permitted_parameters
    logger.debug "Configuring allowing sign up parameters (permitted)"
    devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:display_name, :email, :username)}
  end

  def security_debug_log?
    Global.application.security.debug_log
  end

  def log_user
    Rails.logger.debug "Current user: #{current_user.inspect}"
  end
end
