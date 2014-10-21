class ChannelController < ApplicationController
  def index

  end

  def mychannels
    @
  end

  def browse
  end

  def room
    if params.has_key?(:id)
      id = params(:id).to_i
      @room = Room.find(id)
      render index
    end
  end

  def follow
  end
end
