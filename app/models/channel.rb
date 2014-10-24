# == Schema Information
#
# Table name: channels
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Channel < ActiveRecord::Base
  has_many :messages
  has_many :user_channels
  has_many :users, through: :user_channel
  validates :api_id, presence: true
  validates :api_id, uniqueness: true
  validates :name, presence: true

  def self.get_messages(id)
    h = []
    Message.where(channel_id: id).each do |c|
      h+= [{user: c.user.username, body: c.body}]
    end
    return h
  end

  def get_users
    self.users.all
  end

  def check_in(uid)
    #TODO: Check if user is in it first
    self.user_channels.create(user_id: uid, timeout: DateTime.in(120))
  end

  def cleanup_users
    #TODO: REMOVE INACTIVE USERS
  end

  # extract values from detail json
  def self.parse_detail(show)
    overview = show['overview']
    homepage = show['homepage']
    name = show['name']
    networks = show['networks']

    new_json = {
      overview: overview,
      homepage: homepage,
      name: name,
      network: nil,
    }
    
    if networks.size > 0
      network_name = networks[0]['name']
      p network_name
      new_json[:network] = network_name
    end
    
    return new_json
  end

end
