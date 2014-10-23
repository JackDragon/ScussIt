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
      render :index
    end
  end

  def follow
  end

private

  def message_params
    params.require(:message).permit(:body, :cid)
  end

end

