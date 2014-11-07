# Jon Wu
class HomeController < ApplicationController
	require 'json'
	
	def index
		page_index = 1
		data = ApplicationHelper.airingtoday(page_index)
		airing_today = JSON.parse data

		@results = airing_today['results']
		page = airing_today["total_pages"].to_f

		while (page_index < page)
			page_index += 1
			data = ApplicationHelper.airingtoday(page_index)
			airing_today = JSON.parse data
			@results += airing_today['results']
		end
		
		@favorites_size = 0
		if !current_user.nil?
			@favorites = Favorite.get_favorite(current_user.id)
			for favorite in @favorites do
				channel_id = favorite['api_id'].to_f
				for results in @results do
					if (results["id"] == channel_id)
						@results.insert(0,@results.delete(results))
						@favorites_size += 1
					end
				end
			end
		end

	end
	

	def externalids
		themoviedb = ApplicationHelper::themoviedb
		paramaters = {'api_key'=> themoviedb[:api_key]}
		data = ApplicationHelper.get(themoviedb[:endpoint]+themoviedb[:tv]+params["id"]+themoviedb[:external_ids], paramaters)
		render :json => data
	end
	
	def series
		# endpoint = "http://services.tvrage.com/feeds/showinfo.php?sid="
		endpoint = "http://thetvdb.com/data/series/"
		data = ApplicationHelper.get(endpoint+params['id']+'/')
		json = Hash.from_xml(data).to_json
		render :json => json
	end
	
end
