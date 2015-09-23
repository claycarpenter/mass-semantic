class User < ActiveRecord::Base
  # These modules will determine what functionality Omniauth provides
  devise :registerable, :omniauthable, :omniauth_providers => [:github]

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  VALID_USERNAME_REGEX = /\A[a-z0-9]{1}[\w]+[a-z0-9]{1}\z/i

  validates :username,
    presence: true,
    length: {maximum: 25},
    format: {with: VALID_USERNAME_REGEX},
    uniqueness: {case_sensitive: false}

  validates :email,
    presence: true,
    length: {maximum: 250},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}

  def self.from_omniauth(auth)
    Rails.logger.debug "Looking for user..."

    user = where(provider: auth.provider, uid: auth.uid).first_or_initialize do |user|
      Rails.logger.debug "Auth: #{auth.inspect}"
      Rails.logger.debug "Auth.info: #{auth.info.inspect}"

      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.display_name = auth.info.name
      user.username = auth.info.nickname
    end

    return user;
  end

  def self.new_with_session(params, session)
    Rails.logger.debug "Creating new user from session data?"

    super.tap do |user|
      if data = session["devise.github_data"] && session["devise.github_data"]["extra"]["raw_info"]
        Rails.logger.debug "Incoming data #{data.inspect}"
        Rails.logger.debug "Hydrating user from session: #{user.inspect}"

        user.uid = data["id"] if user.uid.blank?
        user.provider = "github" if user.provider.blank?
        user.email = data["email"] if user.email.nil?
        user.username = data["login"] if user.username.nil?
        user.display_name = data["name"] if user.display_name.nil?

        Rails.logger.debug "Done hydrating user from session: #{user.inspect}"
      end
    end
  end
end
