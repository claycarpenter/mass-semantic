module UserSessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  def logged_in?
    not session[:user_id].nil?
  end

  def log_out
    session.delete :user_id
  end
end
