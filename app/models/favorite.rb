class Favorite < ActiveRecord::Base

	def self.get_favorite(user_id)
		favorites = Favorite.where(user_id:user_id)
	    results = []
	    for favorite in favorites do
	      channel_id = favorite['channel_id']
	      results.push(Channel.find_by(id: channel_id))
	    end
		return results
	end

end