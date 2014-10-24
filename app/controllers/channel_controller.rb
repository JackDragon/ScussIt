class ChannelController < ApplicationController
  def index

  end

  def mychannels
  end

  def browse
  	themoviedb = ApplicationHelper::themoviedb
  	paramaters = {'api_key'=> themoviedb[:api_key], 'page'=> 1}
  	data = ApplicationHelper.get(themoviedb[:endpoint]+themoviedb[:on_the_air], paramaters)
  	@on_the_air = JSON.parse data
  end

  
end
