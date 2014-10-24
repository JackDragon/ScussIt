class ChannelController < ApplicationController
  def index
    @messages = Message.all
  end

  def mychannels
    @favorites = User.find(params[:user]).channels.first(20)
  end

  def browse
    @channels = Channel.all
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
      @messages = @channel.get_messages
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
      if !Channel.find_by(api_id: params[:api_id]).exists?
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

  def create
    Channel.create(channel_params)
  end

  def messages
    m = Message.where(:channel_id => params[:id])
    render json: {messages: m}
  end

  def find
    if params.has_key?(:api_id)
      if Channel.find_by(api_id: params[:api_id]).exists?
        channel = Channel.find_by api_id: params[:api_id]
      else
        channel = Channel.create(channel_params)
        flash[:notice] = "New Channel Created!"
      end
      redirect_to channel_room_path, id: channel.id
    end
  end

private

  def message_params
    params.permit(:body, :channel_id)
  end

  def channel_params
    params.require(:channel).permit(:api_id, :name,:image_url, :network)
  end
end

