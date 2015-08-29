require 'rest-client'


class SeAuthController < ApplicationController
  def callback
    session_code = params[:code]
    logger.debug "Received this code from SE: #{session_code}"

    # ... and POST it back to Stack Exchange
    result = RestClient.post('https://stackexchange.com/oauth/access_token',
                            {:client_id => ENV['stackex_client_id'],
                             :client_secret => ENV['stackex_client_secret'],
                             :code => session_code,
                            :redirect_uri => "http://localhost:3000/se_auth/callback"},
                             :accept => :json)

    logger.debug result.inspect

    result_parser = /access_token\=(?<access_token>[^\&]*)/
    parsed = result_parser.match result
    logger.debug parsed.inspect
    access_token = parsed[:access_token]
    logger.debug "Access token: #{access_token}"

    # ... and POST it back to Stack Exchange
    #me_url = "https://api.stackexchange.com/2.2/me?order=desc&sort=reputation&site=stackoverflow&access_token=#{access_token}&key=#{ENV['stackex_client_secret']}"

    me_url = "https://api.stackexchange.com/2.2/me?key=#{ENV['stackex_client_key']}&site=stackoverflow&order=desc&sort=reputation&access_token=#{access_token}&filter=default"
    logger.debug "Request URL: #{me_url}"
    begin
      result = RestClient.get(me_url, :accept => :json)
      logger.debug result
    rescue => error
      logger.error error
      logger.error error.inspect
    end
  end
end
