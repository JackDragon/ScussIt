# # Jon Wu
# require 'rails_helper'
#
# describe HomeController, "#http_request" do
# 	it "airingtoday should not be null" do
# 		results = get :airingtoday, :page => 1
# 		expect(results).not_to be_nil
# 	end
# end

require 'spec_helper'
require 'rails_helper'

describe HomeController do

	describe "when there are favorites" do
	    it "checks if they are live" do
	      
	      u = User.new(:email => "q@q.com", :password => "password", username: 'joe')
	      c = Channel.create(:name => "Seinfeld", :image_url => "google.com", :network => "NBC", :api_id => 60743)
	      f = Favorite.create(:user_id => u.id, :channel_id => c.id)
	      @results = [{"backdrop_path"=>"/ocWDGFHxddYWcZYeenO1y7ULeIi.jpg", "id"=>39351, "original_name"=>"Grimm", "first_air_date"=>"2011-10-28", "origin_country"=>["US"], "poster_path"=>"/ab8dDToLQKQf3iycY0ES8KDppv5.jpg", "popularity"=>14.7987649555232, "name"=>"Grimm", "vote_average"=>8.6, "vote_count"=>7}, {"backdrop_path"=>"/2NLScVRdqI0kl4UTSCda6lltlCE.jpg", "id"=>60743, "original_name"=>"Constantine", "first_air_date"=>"2014-10-24", "origin_country"=>["US"], "poster_path"=>"/hl3moOP6ZBM1ACFYgwQmViO3RsY.jpg", "popularity"=>9.64286425119666, "name"=>"Constantine", "vote_average"=>0.0, "vote_count"=>0}]
	      result = HomeHelper.reorder_favorites(@results, u)[1]

	      expect(result).to eq([{"backdrop_path"=>"/2NLScVRdqI0kl4UTSCda6lltlCE.jpg", "id"=>60743, "original_name"=>"Constantine", "first_air_date"=>"2014-10-24", "origin_country"=>["US"], "poster_path"=>"/hl3moOP6ZBM1ACFYgwQmViO3RsY.jpg", "popularity"=>9.64286425119666, "name"=>"Constantine", "vote_average"=>0.0, "vote_count"=>0}, {"backdrop_path"=>"/ocWDGFHxddYWcZYeenO1y7ULeIi.jpg", "id"=>39351, "original_name"=>"Grimm", "first_air_date"=>"2011-10-28", "origin_country"=>["US"], "poster_path"=>"/ab8dDToLQKQf3iycY0ES8KDppv5.jpg", "popularity"=>14.7987649555232, "name"=>"Grimm", "vote_average"=>8.6, "vote_count"=>7}])
	    end
	end

end
