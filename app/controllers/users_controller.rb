class UsersController < ApplicationController
  def new
    if not has_oauth?
      redirect_to "/login"

      return
    end

    oauth_data = get_oauth

    logger.debug "data: #{oauth_data}"

    @user = User.new
    @user.display_name = oauth_data["full_name"]
    @user.email = oauth_data["email"]

    logger.debug "User: #{@user.inspect}"
  end

  def create
    @user = User.new(user_params)

    oauth_data = get_oauth

    if (oauth_data["oauth_service"] == "github")
      @user.gh_user_id = oauth_data["user_id"]
    elsif (oauth_data["oauth_service"] == "stackex")
      @user.se_user_id = oauth_data["user_id"]
    end

    logger.debug "Saving this user data: #{@user.inspect}"

    if @user.save
      log_in @user
      
      redirect_to @user
    else
      render "new"
    end
  end

  def show
    id = params[:id]

    @user = User.find(id)
  end

  private
    def user_params
      params.require(:user).permit(:display_name, :email)
    end
end
