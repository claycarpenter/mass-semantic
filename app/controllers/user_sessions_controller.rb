class UserSessionsController < ApplicationController
  def new
  end

  def destroy
    log_out

    redirect_to '/'
  end

  def github
    logger.debug "Redirecting client to GitHub"

    oauth_url = "https://github.com/login/oauth/authorize?scope=user:email&client_id=#{ Global.application.oauth.github.client_id}&redirect_uri=#{Global.hosts.web}#{Global.application.oauth.github.callback}"

    redirect_to oauth_url
  end

  def github_callback
    logger.debug "Received GH callback."

    callback_code = params[:code]
    logger.debug "Received this code from GH: #{callback_code}"

    github_handler = UserSessionsHelper::GitHubOAuthHandler.new
    oauth_result = github_handler.handle(callback_code)

    logger.debug "Looking for registered user with gh user id '#{oauth_result.user_id}'"

    registered_user = User.find_by(gh_user_id: oauth_result.user_id)

    if !registered_user.nil?
      logger.debug "Found user: #{registered_user.inspect}"

      # Log in user
      log_in registered_user

      redirect_to user_url(id: registered_user.id)
    else
      logger.debug "Could not find user; auth error."

      redirect_to "/sign-in"
    end
  end

  def stackex
    logger.debug "Redirecting client to Stack Exchane"

    oauth_url = "https://stackexchange.com/oauth?client_id=#{Global.application.oauth.stackex.client_id}&scope=&redirect_uri=#{Global.hosts.web}#{Global.application.oauth.stackex.callback}"

    redirect_to oauth_url
  end

  def stackex_callback
    session_code = params[:code]
    logger.debug "Received this code from SE: #{session_code}"

    if params.has_key? "error"
      logger.debug "Found error: #{params[:error]}"
      redirect_to "/sign-in"

      return
    end

    # ... and POST it back to Stack Exchange
    result = RestClient.post('https://stackexchange.com/oauth/access_token',
                            {:client_id => Global.application.oauth.stackex.client_id,
                             :client_secret => Global.application.oauth.stackex.secret_key,
                             :code => session_code,
                            :redirect_uri => "#{Global.hosts.web}#{Global.application.oauth.stackex.callback}"},
                             :accept => :json)

    logger.debug result.inspect

    result_parser = /access_token\=(?<access_token>[^\&]*)/
    parsed = result_parser.match result
    access_token = parsed[:access_token]
    logger.debug "Access token: #{access_token}"

    begin

      # Sites Query
      sites_url = "https://api.stackexchange.com/2.2/sites?pagesize=1000&filter=!SmNnbu6IMQSQAW0(lU&key=#{Global.application.oauth.stackex.client_key}"

      raw_result = RestClient.get(sites_url, :accept => :json)
      sites_result = JSON.parse(raw_result)

      network_sites = sites_result["items"]
      logger.debug "Network sites count: #{network_sites.length}"

      # Associated Query
      associated_url = me_url = "https://api.stackexchange.com/2.2/me/associated?key=#{Global.application.oauth.stackex.client_key}&access_token=#{access_token}"
      associated_results = JSON.parse(RestClient.get(associated_url, :accept => :json))
      # logger.debug associated_results["items"]
      associated_accounts = associated_results["items"]
      logger.debug "Associated accounts count: #{associated_accounts.length}"

      api_site_keys = []

      associated_accounts.each do |account|
        # logger.debug account.inspect
        # logger.debug account["site_name"]

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
        me_url = "https://api.stackexchange.com/2.2/me?key=#{Global.application.oauth.stackex.client_key}&site=#{site_key}&order=desc&sort=reputation&access_token=#{access_token}&filter=default"
        logger.debug "Request URL: #{me_url}"

        result = JSON.parse(RestClient.get(me_url, :accept => :json))
        temp_display_name = result["items"][0]["display_name"].strip

        if !temp_display_name.empty?
          is_name_found = true
          @display_name = result["items"][0]["display_name"]
          logger.debug "Collected display name"
          user_id = result["items"][0]["account_id"]
          logger.debug "account id: #{user_id}"
        end
      end

      logger.debug "Display name: #{@display_name}"

      logger.debug "Looking for registered user with se user id '#{user_id}'"

      registered_user = User.find_by(se_user_id: user_id)

      if !registered_user.nil?
        logger.debug "Found user: #{registered_user.inspect}"

        # Log in user
        log_in registered_user

        # FIXME Pretty sure this is the wrong way to redirect to a user profile
        redirect_to user_url(id: registered_user.id)
      else
        logger.debug "Could not find user; auth error."

        redirect_to "sign_in"
      end
    rescue => error
      logger.error error
      logger.error error.inspect
    end
  end
end
