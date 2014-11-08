module HomeHelper
	def self.reorder_favorites(current_result, current_user)
		favorites_size = 0
		if !current_user.nil?
			favorites = Favorite.get_favorite(current_user.id)
			for favorite in favorites do
				channel_id = favorite['api_id'].to_f
				for results in current_result do
					if (results["id"] == channel_id)
						current_result.insert(0,current_result.delete(results))
						favorites_size += 1
					end
				end
			end
		end
		return [favorites_size, current_result]
	end
end
