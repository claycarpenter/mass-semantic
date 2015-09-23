class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include UserSessionsHelper

  # TODO: Not sure if these two helpers are necessary...
  def new_session_path(scope)
    new_user_session_path
  end

  def session_path(scope)
    user_session_path
  end
end
