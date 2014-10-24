require 'spec_helper'
require 'rails_helper'

describe ChannelController do
  # before :each do
  # end
  # it "should make channel" do
  #   c = Channel.new(:name => "Seinfeld", :image_url => "google.com", :network => "NBC", :api_id => 35)
  #   expect(c.save).to be(true)
  # end

  describe "channel GET index" do
    it "has a 200 status code" do
      get :index
      expect(response.status).to eq(200)
    end
  end
end