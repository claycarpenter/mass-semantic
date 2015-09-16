module UserSessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  def logged_in?
    not current_user.nil?
  end

  def current_user
    # If the current user is already defined; return that.
    # Otherwise, look up the current user via a session's user id.
    # If session id is undefined or user is not found for given id, return nil.
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def log_out
    session.delete :user_id
  end
end
