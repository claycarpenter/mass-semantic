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

    logger.debug oauth_result.inspect

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
    logger.debug "Redirecting client to Stack Exchange"

    oauth_url = "https://stackexchange.com/oauth?client_id=#{Global.application.oauth.stackex.client_id}&scope=&redirect_uri=#{Global.hosts.web}#{Global.application.oauth.stackex.callback}"

    redirect_to oauth_url
  end

  def stackex_callback
    if params.has_key? "error"
      logger.debug "Found error: #{params[:error]}"
      redirect_to "/sign-in"

      return
    end

    callback_code = params[:code]
    logger.debug "Received this code from SE: #{callback_code}"

    begin
      stackex_handler = UserSessionsHelper::StackExOAuthHandler.new
      oauth_result = stackex_handler.handle(callback_code)

      logger.debug "Looking for registered user with se user id '#{oauth_result.user_id}'"

      registered_user = User.find_by(se_user_id: oauth_result.user_id)

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
