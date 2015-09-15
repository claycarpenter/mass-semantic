class AuthController < ApplicationController
  def sign_in
    # TODO: These really should be part of the app configuration, not
    # dynamically generated for each request.
    @urls = {
      :github => "https://github.com/login/oauth/authorize?scope=user:email&client_id=#{ ENV['github_client_id']}",
      :stackex => "https://stackexchange.com/oauth?client_id=#{ENV['stackex_client_id']}&scope=&redirect_uri=http://localhost:3000/se_auth/callback"
    }
  end

  def sign_up
  end
end
