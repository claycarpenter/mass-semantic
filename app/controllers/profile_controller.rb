class ProfileController < ApplicationController
  def public
    @is_private = false

    render :show
  end

  def private
    @is_private = true
    
    render :show
  end

  def show
  end
end
