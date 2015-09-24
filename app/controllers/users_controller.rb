class UsersController < ApplicationController
  load_and_authorize_resource :only => [:edit, :update, :destroy]

  def new
    if not has_oauth?
      redirect_to "/login"

      return
    end

    oauth_data = get_oauth

    logger.debug "data: #{oauth_data}"

    @user = User.new
    @user.username = oauth_data["username"]
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
      # Persistence/validation errors; render new page with errors.
      render "new"
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(user_params)
      render "show"
    else
      # Errors in persisting updates; return to form with errors.
      render "edit"
    end
  end

  def destroy
    id = params[:id].to_i

    logger.debug "Looking for user #{id}"
    logger.debug "Current user is: #{current_user.inspect}"

    if (id == current_user.id)
      logger.debug "Deleting user #{current_user.inspect}"
      User.delete(id)

      sign_out(current_user)
    end

    redirect_to root_path
  end

  private
    def user_params
      params.require(:user).permit(:display_name, :email, :username)
    end
end
