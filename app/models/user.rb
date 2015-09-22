class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :omniauthable, :registerable,
         :trackable, :validatable, :confirmable

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
end
