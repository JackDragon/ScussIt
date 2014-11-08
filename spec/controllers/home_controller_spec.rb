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
	      c = Channel.create(:name => "Seinfeld", :image_url => "google.com", :network => "NBC", :api_id => 35)
	      c_2 = Channel.create(:name => "Vampire Diary", :image_url => "google.com", :network => "NBC", :api_id => 34)
	      f = Favorite.create(:user_id => u.id, :channel_id => c_2.id)

	      get :index
	      p @favorites_size
	      expect(response.status).to eq(200)
	    end
	end

end
