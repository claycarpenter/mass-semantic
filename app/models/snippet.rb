class Snippet < ActiveRecord::Base
  # Relations
  belongs_to :user

  has_many :comments

  # Validations
  validates :title,
    presence: true,
    length: {minimum: 5, maximum: 150}

  validates :code,
    presence: true,
    length: {minimum: 10}

  validates :expl_md,
    presence: true,
    length: {minimum: 5}

  validates :user_id,
    presence: true
end
