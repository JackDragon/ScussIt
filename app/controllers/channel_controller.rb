class ChannelController < ApplicationController
  def index
    @messages = Message.all
  end

  def mychannels
    @favorites = User.find(params[:user]).channels.first(20)
  end

  # Get all shows from MovieDB
  def browse
    themoviedb = ApplicationHelper::themoviedb
    paramaters = {'api_key'=> themoviedb[:api_key], 'page'=> 1}
    data = ApplicationHelper.get(themoviedb[:endpoint]+themoviedb[:on_the_air], paramaters)
    @on_the_air = JSON.parse data
  end

  # Get details of a show from MovieDB
  def details
    themoviedb = ApplicationHelper::themoviedb
    paramaters = {'api_key'=> themoviedb[:api_key]}
    data = ApplicationHelper.get(themoviedb[:endpoint]+themoviedb[:tv]+params["id"],paramaters)
    show = JSON.parse data
    new_json = Channel.parse_detail(show)
    render :json => new_json
  end

  def post
    if user_signed_in?
      @message = current_user.messages.create!(message_params)
    else
      @message = Message.create!(message_params)
    end
    render :json => {success: 1}
    
  end

  def room
    if params.has_key?(:id)
      id = params[:id].to_i
      @channel = Channel.find(id)
      @messages = Channel.get_messages(params[:id])
      @user = current_user
      render :index
    end
  end

  def follow
    if params.has_key?(:cid)
      if !current_user.favorites.exists?(:channel_id => params[:cid])
        current_user.favorites.create(:channel_id => params[:cid])
      end
    elsif params.has_key?(:api_id)

      if Channel.find_by(api_id: params[:api_id]) == nil
        Channel.create(channel_params)
      end
      cid = (Channel.find_by api_id: params[:api_id]).id
      if !current_user.favorites.exists?(:channel_id => cid)
        current_user.favorites.create(:channel_id => cid)
      end
    end
    render nothing: true
  end

  def unfollow
    cid = nil
    if params.has_key?(:cid)
      cid = params[:cid]
    elsif params.has_key(:api_id)
      cid = (Channel.find_by api_id: params[:api_id]).id
    end
    if current_user.favorites.exists?(:channel_id => cid)
      # to_delete = current_user.favorites.where(:channel_id => params[:cid])
      to_delete = Favorite.where(:channel_id => cid, :user_id => current_user.id)[0]
      Favorite.destroy(to_delete.id)
      # render json: {errCode: to_delete}
    end
    render nothing: true
  end

  def check_follow
    if params.has_key?(:id)
      following = Favorite.find_by api_id => params[:id] != nil
      return following
    end
    return false
  end

  def create
    Channel.create(channel_params)
  end

  def messages
    # m = Message.where(:channel_id => params[:id])
    # render json: {messages: m}
    render json: {messages: Channel.get_messages(params[:id])}
  end

  def find
    if params.has_key?(:api_id)
      # if Channel.exists?(api_id: params[:api_id])
      #   channel = Channel.find_by api_id: params[:api_id]
      # else
      #   channel = Channel.create!(channel_params)
      #   flash[:notice] = "New Channel Created!"
      # end
      channel = Channel.find_or_create_by!(api_id: params[:api_id]) do |c|
        c.name = params[:name]
        c.image_url = params[:image_url]
        c.network = params[:network]
      end

      redirect_to channel_room_path(channel.id)#, id: channel.id
    end
  end

private

  def message_params
    params.permit(:body, :channel_id)
  end

  def channel_params
    params.permit(:api_id, :name, :image_url, :network)
  end

  
end

