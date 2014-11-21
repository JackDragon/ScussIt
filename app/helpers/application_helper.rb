# Jon Wu
module ApplicationHelper

	require 'rest_client'

	def self.thetvdb
		thetvdb={
			api_key: "7FE56AB14EBC6348",
			endpoint: "http://thetvdb.com"
		}
		return thetvdb
	end

	def self.themoviedb
		themoviedb = {
			api_key: "8dbcc916cb5179dbcc6f9c06145f3085",
			endpoint: "https://api.themoviedb.org/3",
			airing_today: "/tv/airing_today",
			on_the_air: "/tv/on_the_air",
			search: "/search/tv",
			tv: "/tv/",
			external_ids:"/external_ids"
		}
		return themoviedb
		
	end

	# Make a GET http request
	def self.get(endpoint, parameters = nil)
		puts endpoint
		body = RestClient.get endpoint, {:params => parameters}
		return body
	end

	# Get airingtoday
	def self.airingtoday(page)
		themoviedb = ApplicationHelper::themoviedb
		paramaters = {'api_key'=> themoviedb[:api_key], 'page'=> page}
		data = ApplicationHelper.get(themoviedb[:endpoint]+themoviedb[:airing_today], paramaters)
		return data
	end


end
