class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :snippet

  validates :user,
    presence: true

  validates :snippet,
    presence: true

  validates :body_md,
    presence: true,
    length: { minimum: 3, maximum: 500 }
end
