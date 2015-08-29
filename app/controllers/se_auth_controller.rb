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

    begin

      # Sites Query
      sites_url = "https://api.stackexchange.com/2.2/sites?pagesize=1000&filter=!SmNnbu6IMQSQAW0(lU&key=#{ENV['stackex_client_key']}"
      sites_result = JSON.parse(RestClient.get(sites_url, :accept => :json))

      logger.debug sites_result["items"]
      network_sites = sites_result["items"]
      logger.debug "Network sites count: #{network_sites.length}"

      # Associated Query
      associated_url = me_url = "https://api.stackexchange.com/2.2/me/associated?key=#{ENV['stackex_client_key']}&access_token=#{access_token}"
      associated_results = JSON.parse(RestClient.get(associated_url, :accept => :json))
      logger.debug associated_results["items"]
      associated_accounts = associated_results["items"]
      logger.debug "Associated accounts count: #{associated_accounts.length}"

      api_site_keys = []

      associated_accounts.each do |account|
        # logger.debug account.inspect
        logger.debug account["site_name"]

        network_sites.each do |site|
          if account["site_url"] == site["site_url"]
            logger.debug "Found a match! #{account["site_name"]} matches site api key #{site["api_site_parameter"]}"

            api_site_keys.push site["api_site_parameter"]
          end
        end
      end

      is_name_found = false
      while !is_name_found && !api_site_keys.empty?
        # Me (user details) Query
        site_key = api_site_keys.pop
        me_url = "https://api.stackexchange.com/2.2/me?key=#{ENV['stackex_client_key']}&site=#{site_key}&order=desc&sort=reputation&access_token=#{access_token}&filter=default"
        logger.debug "Request URL: #{me_url}"

        result = JSON.parse(RestClient.get(me_url, :accept => :json))
        # logger.debug result
        logger.debug result["items"][0]
        temp_display_name = result["items"][0]["display_name"].strip

        if !temp_display_name.empty?
          is_name_found = true
          @display_name = result["items"][0]["display_name"]
        end
      end

      logger.debug "Display name: #{@display_name}"

    rescue => error
      logger.error error
      logger.error error.inspect
    end
  end
end
