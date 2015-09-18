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

  class OAuthData
    attr_accessor :oauth_service, :user_id, :username, :full_name, :email
  end

  class GitHubOAuthHandler
    def handle(callback_code)
      # ... and POST it back to GitHub
      result = RestClient.post('https://github.com/login/oauth/access_token',
                              {:client_id => Global.application.oauth.github.client_id,
                               :client_secret => Global.application.oauth.github.secret_key,
                               :code => callback_code},
                               :accept => :json)

      access_token = JSON.parse(result)['access_token']

      # fetch user information
      user_result = JSON.parse(RestClient.get('https://api.github.com/user',
                                          {:params => {:access_token => access_token}}))

      oauth_data = OAuthData.new
      oauth_data.oauth_service = :github
      oauth_data.user_id = user_result["login"]
      oauth_data.username = user_result["login"]
      oauth_data.full_name = user_result["name"]
      oauth_data.email = user_result["email"]

      return oauth_data
    end
  end
end
