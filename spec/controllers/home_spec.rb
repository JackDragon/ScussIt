# Jon Wu
require 'rails_helper'

describe HomeController, "#http_request" do
	it "airingtoday should not be null" do
		results = get :airingtoday, :page => 1
		expect(results).not_to be_nil
	end
end