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

  def submit
    p params
    @message = Message.create!(message_params)
    redirect_to '/test'
  end

private

def message_params
  params.require(:message).permit(:body)
end
end