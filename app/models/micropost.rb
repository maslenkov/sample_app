class Micropost < ActiveRecord::Base
  default_scope -> { order 'created_at desc' }

  attr_accessible :content, :user_id

  belongs_to :user

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }

  def self.from_users_followed_by(user)
    followed_user_ids = 'select followed_id from relationships
      where follower_id = :user_id'
    where("user_id in (#{followed_user_ids}) or user_id = :user_id",
      user_id: user)
  end
end
