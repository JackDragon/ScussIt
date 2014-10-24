class ChannelController < ApplicationController
  def index
    @messages = Message.all
  end

  def mychannels
    @favorites = User.find(params[:user]).channels.first(20)
  end

  def browse
    themoviedb = ApplicationHelper::themoviedb
    paramaters = {'api_key'=> themoviedb[:api_key], 'page'=> 1}
    data = ApplicationHelper.get(themoviedb[:endpoint]+themoviedb[:on_the_air], paramaters)
    @on_the_air = JSON.parse data
  end


  def post
  	p "---"*80
  	p params
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
    end
    redirect_to channel_room_path
  end

  def unfollow
    if params.has_key?(:cid)
      if current_user.favorites.exists?(:channel_id => params[:cid])
        # to_delete = current_user.favorites.where(:channel_id => params[:cid])
        to_delete = Favorite.where(:channel_id => params[:cid], :user_id => current_user.id)[0]
        Favorite.destroy(to_delete.id)
        # render json: {errCode: to_delete}
      end
    end
    redirect_to channel_room_path
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

