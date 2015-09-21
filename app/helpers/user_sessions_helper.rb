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

  def require_login
    unless logged_in?
      flash[:error] = "You must be logged in to create or edit snippets."

      redirect_to login_path
    end
  end

  def store_oauth(oauth_data)
    Rails.logger.debug "Storing OAuth data: #{oauth_data.inspect}"

    session[:oauth] = oauth_data
  end

  def get_oauth
    session[:oauth]
  end

  def has_oauth?
    (session.has_key?(:oauth)) && (not session[:oauth]["access_token"].nil?)
  end

  class OAuthData
    attr_accessor :access_token, :oauth_service, :user_id, :username, :full_name, :email
  end

  class GitHubOAuthHandler
    def get_access_token(callback_code)
      # Acquire access token by sending callback code back to GitHub
      options_hash = { :client_id => Global.application.oauth.github.client_id,         :client_secret => Global.application.oauth.github.secret_key,         :code => callback_code }

      result = RestClient.post('https://github.com/login/oauth/access_token',
                              options_hash,
                               :accept => :json)

      access_token = JSON.parse(result)['access_token']
    end

    def get_user_details(oauth_data)
      user_result = JSON.parse(RestClient.get('https://api.github.com/user',
                                          {:params => {:access_token => oauth_data.access_token}}))

      oauth_data.user_id = user_result["login"]
      oauth_data.username = user_result["login"]
      oauth_data.full_name = user_result["name"]
      oauth_data.email = user_result["email"]
    end

    def handle(callback_code)
      oauth_data = OAuthData.new
      oauth_data.oauth_service = :github

      # Acquire access token
      oauth_data.access_token = self.get_access_token(callback_code)

      # Fetch user information
      self.get_user_details(oauth_data)

      return oauth_data
    end
  end

  class StackExOAuthHandler
    def get_access_token(callback_code)
      # Acquire access token by sending callback code back to GitHub
      result = RestClient.post('https://stackexchange.com/oauth/access_token',
                              {:client_id => Global.application.oauth.stackex.client_id,
                               :client_secret => Global.application.oauth.stackex.secret_key,
                               :code => callback_code,
                              :redirect_uri => "#{Global.hosts.web}#{Global.application.oauth.stackex.callback}"},
                               :accept => :json)

      result_parser = /access_token\=(?<access_token>[^\&]*)/
      parsed = result_parser.match result
      access_token = parsed[:access_token]
    end

    def get_user_details(oauth_data)
      # Sites Query
      sites_url = "https://api.stackexchange.com/2.2/sites?pagesize=1000&filter=!SmNnbu6IMQSQAW0(lU&key=#{Global.application.oauth.stackex.client_key}"

      raw_result = RestClient.get(sites_url, :accept => :json)
      sites_result = JSON.parse(raw_result)

      network_sites = sites_result["items"]

      # Associated Query
      associated_url = me_url = "https://api.stackexchange.com/2.2/me/associated?key=#{Global.application.oauth.stackex.client_key}&access_token=#{oauth_data.access_token}"
      associated_results = JSON.parse(RestClient.get(associated_url, :accept => :json))
      associated_accounts = associated_results["items"]

      api_site_keys = []

      associated_accounts.each do |account|
        network_sites.each do |site|
          if account["site_url"] == site["site_url"]
            api_site_keys.push site["api_site_parameter"]
          end
        end
      end

      is_name_found = false
      while !is_name_found && !api_site_keys.empty?
        # Me (user details) Query
        site_key = api_site_keys.pop
        me_url = "https://api.stackexchange.com/2.2/me?key=#{Global.application.oauth.stackex.client_key}&site=#{site_key}&order=desc&sort=reputation&access_token=#{oauth_data.access_token}&filter=default"

        result = JSON.parse(RestClient.get(me_url, :accept => :json))
        temp_display_name = result["items"][0]["display_name"].strip

        if !temp_display_name.empty?
          is_name_found = true
          display_name = result["items"][0]["display_name"]
          user_id = result["items"][0]["account_id"]

          break
        end
      end

      oauth_data.user_id = user_id
      oauth_data.full_name = display_name
      # StackEx doesn't provide email via APIs.
    end

    def handle(callback_code)
      oauth_data = OAuthData.new
      oauth_data.oauth_service = :stackex

      # Acquire access token
      oauth_data.access_token = self.get_access_token(callback_code)

      # Fetch user information
      self.get_user_details(oauth_data)

      return oauth_data
    end
  end
end
