class HomeController < ApplicationController
	require 'json'
	
	def index
		
	end
	def airingtoday
		themoviedb = HomeHelper::themoviedb
		paramaters = {'api_key'=> themoviedb[:api_key], 'page'=> params['page']}
		data = HomeHelper.get(themoviedb[:endpoint]+themoviedb[:airing_today], paramaters)
		render :json => data	
	end

	def externalids
		themoviedb = HomeHelper::themoviedb
		paramaters = {'api_key'=> themoviedb[:api_key]}
		data = HomeHelper.get(themoviedb[:endpoint]+themoviedb[:tv]+params["id"]+themoviedb[:external_ids], paramaters)
		render :json => data
	end
	
	def series
		# endpoint = "http://services.tvrage.com/feeds/showinfo.php?sid="
		endpoint = "http://thetvdb.com/data/series/"
		data = HomeHelper.get(endpoint+params['id']+'/')
		json = Hash.from_xml(data).to_json
		render :json => json
	end
	
end
