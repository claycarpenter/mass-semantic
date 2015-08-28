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
                             
    logger.debug result.inspect
  end

  def sign_in
    logger.debug 'Test of logging from sign_in.'
  end
end
