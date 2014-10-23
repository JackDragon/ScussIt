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
    redirect_to channel_room_path
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

private

  def message_params
    params.require(:message).permit(:body, :channel_id)
  end

end

