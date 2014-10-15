class HomeController < ApplicationController

	def index
		
	end

	def getseries
		require 'net/http'
		require 'json'

		url = URI.parse('http://thetvdb.com/data/series/'+params['id']+'/')
		req = Net::HTTP::Get.new(url.to_s)
		res = Net::HTTP.start(url.host, url.port) {|http|
		  http.request(req)
		}
		xml = res.body
		json = Hash.from_xml(xml).to_json
		render :json => json
	end
	
end
