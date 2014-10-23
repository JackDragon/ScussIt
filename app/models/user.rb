class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  has_many :messages
  has_many :favorites
  has_many :channels, through: :favorites

  def follow(uid, cid)
    # :user = User.find(uid)
    @already = User.favorites.where("user_id = ? and channel_id = ?", uid, cid)
    if !@already.any?
      User.favorites.create(user_id: uid, channel_id: cid)
    end
  end
end