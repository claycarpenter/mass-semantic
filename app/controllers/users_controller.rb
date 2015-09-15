class UsersController < ApplicationController
  def new
  end

  def show
    id = params[:id]

    logger.debug "Requested ID: #{id}"

    @user = User.find(id)
  end
end
