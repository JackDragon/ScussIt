class Message < ActiveRecord::Base
  belongs_to :user
  belongs_to :channel
  validates :user_id, presence: true
  validates :body, presence: true
  validates :channel_id, presence: true

end
