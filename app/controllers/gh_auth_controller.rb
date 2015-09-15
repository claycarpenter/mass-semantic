require 'rest-client'

class GhAuthController < ApplicationController
  def callback
    session_code = params[:code]
    logger.debug 'Test of logging from callback.'
    logger.debug "Received this code from GH: #{session_code}"

    # ... and POST it back to GitHub
    result = RestClient.post('https://github.com/login/oauth/access_token',
                            {:client_id => ENV['github_client_id'],
                             :client_secret => ENV['github_client_secret'],
                             :code => session_code},
                             :accept => :json)

    logger.debug "Have access token result"
    logger.debug result.inspect

    access_token = JSON.parse(result)['access_token']

    logger.debug "Using this access token: #{access_token}"

    # fetch user information
    user_result = JSON.parse(RestClient.get('https://api.github.com/user',
                                        {:params => {:access_token => access_token}}))

    logger.debug user_result
    logger.debug "Username: #{user_result["login"]}"
    logger.debug "Display name: #{user_result["name"]}"
    @display_name = user_result["name"]

    user_id = user_result["login"]
    logger.debug "Looking for registered user with gh user id '#{user_id}'"

    registered_user = User.find_by(gh_user_id: user_id)

    if !registered_user.nil?
      logger.debug "Found user: #{registered_user.inspect}"

      redirect_to user_url(id: registered_user.id)
    else
      logger.debug "Could not find user; auth error."

      redirect_to "/sign-in"
    end
  end

  def sign_in
    logger.debug 'Test of logging from sign_in.'
  end
end
