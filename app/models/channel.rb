# Renjie Long
# Bryant Chang
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
  has_many :topics
  validates :api_id, presence: true
  validates :api_id, uniqueness: true
  validates :name, presence: true
  after_create :create_main

  def create_main
    self.topics.find_or_create_by!(:name => "Main") do |t|
    end
  end

  def create_topic(params, current_user)
    name = params[:topic_names][0]
    self.topics.find_or_create_by!(:name => name) do |t|
      t.name = name
    end
  end

  def self.get_messages(id)
    h = []
    Message.where(channel_id: id).each do |m|
      h+= [{user: m.user.username, body: m.body, topic_name: m.topic_name}]
    end
    return h
  end

  def self.get_topics(id)
    h = []
    Topic.where(channel_id: id).each do |t|
      h+= [t.name]
    end
    return h
  end

  def get_user_count(id, topic_name)
    timenow = DateTime.now
    return Active.where(:channel_id => id, :topic_name => topic_name).where("updated > ?", timenow-5.seconds).size
  end

  def get_users
    self.users.all
  end

  def check_in(uid)
    #TODO: Check if user is in it first
    self.user_channels.create(user_id: uid, timeout: DateTime.in(120))
  end

  # extract values from detail json
  def self.parse_detail(show)
    p "*"*80
    p show
    overview = show['overview']
    homepage = show['homepage']
    name = show['name']
    networks = show['networks']
    poster_path = show['poster_path']
    id = show['id']
    new_json = {
      id:id,  
      overview: overview,
      homepage: homepage,
      name: name,
      poster_path: poster_path,
      network: nil,
    }
    
    if networks.size > 0
      network_name = networks[0]['name']
      p network_name
      new_json[:network] = network_name
    end
    
    return new_json
  end

  def self.follow(params, current_user, channel_params)
    if params.has_key?(:cid)
      if !current_user.favorites.exists?(:channel_id => params[:cid])
        current_user.favorites.create(:channel_id => params[:cid])
      end
    elsif params.has_key?(:api_id)

      if Channel.find_by(api_id: params[:api_id]) == nil
        Channel.create(channel_params)
      end
      # p Channel.find_by api_id: params[:api_id]
      cid = (Channel.find_by api_id: params[:api_id]).id
      if !current_user.favorites.exists?(:channel_id => cid)
        current_user.favorites.create(:channel_id => cid)
      end
    end
  end

  def self.unfollow(params, current_user)
    cid = nil
    if params.has_key?(:cid)
      cid = params[:cid]
    elsif params.has_key?(:api_id)
      cid = (Channel.find_by api_id: params[:api_id]).id
    end
    if current_user.favorites.exists?(:channel_id => cid)
      to_delete = Favorite.where(:channel_id => cid, :user_id => current_user.id)[0]
      Favorite.destroy(to_delete.id)
    end
  end

  def self.following(params, current_user)
    following = false
    if params.has_key?(:id) and (Channel.find_by api_id: params[:id]) != nil and current_user != nil
      id = (Channel.find_by api_id: params[:id]).id
      following = Favorite.find_by(channel_id: id, user_id: current_user.id) !=nil
    end
    return following
  end

  def self.active_delete(params, current_user)
    cid = nil
    # topic_names = params[:topic_names]
    if params.has_key?(:cid)
      cid = params[:cid]
      # topic_names = params[:topic_names]
    elsif params.has_key?(:api_id) and Channel.find_by(api_id: params[:api_id]) != nil
      cid = (Channel.find_by api_id: params[:api_id]).id
    end
    if current_user.actives.exists?(:channel_id => cid)
      for to_delete in Active.where(:channel_id => cid, :user_id => current_user.id)[0]
        Active.destroy(to_delete.id)
      end
    end
  end

  def self.active_update(params, current_user)
    if current_user != nil
      cid = nil
      topic_names = params[:topic_names]
      if params.has_key?(:cid)
        cid = params[:cid]
      end
      if cid != nil
        for top in topic_names
          entry = Active.find_by(channel_id: cid, user_id: current_user.id, :topic_name => top)
          entry.update(updated: DateTime.now)
        end
      end
    end
  end

  def self.active_add(params, current_user)
    cid = nil
    topic_names = nil
    if params.has_key?(:topic_names)
      topic_names = params[:topic_names]
    else
      topic_names = ["Main"]
    end
    if params.has_key?(:cid)
      cid = params[:cid]
    elsif params.has_key?(:api_id) and Channel.find_by(api_id: params[:api_id]) != nil
      cid = (Channel.find_by api_id: params[:api_id]).id
    end
    for top in topic_names
      if cid != nil and !current_user.actives.exists?(:channel_id => cid, :topic_name => top)
        current_user.actives.create(:channel_id => cid, :topic_name => top, :updated => DateTime.now)
      end
    end
  end

  def self.active_user_list(params, current_user)
    # p params
    active_dict = {}
    topics = Topic.where(:channel_id => cid)
    for top in topics
      l = []
      timenow = DateTime.now
      cid = params[:id]
      if cid != nil and Active.exists?(:channel_id => cid, :topic_name => top.topic_name)
        l = Active.where(:channel_id => cid, :topic_name => top.topic_name).where("updated > ?", timenow-5.seconds)
      end
      userlist = []
      for entry in l
        # p "ENTRY"*100
        # p entry
        eid = entry.user_id
        username = User.where(:id => eid)[0].username
        # entry["username"] = username
        userlist += [username]
      end
      active_dict[top.topic_name] = userlist
      return active_dict
    end
  end
end
