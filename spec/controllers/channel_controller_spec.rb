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

  # it "channel post message" do
  #   c = Channel.create(:name => "Seinfeld", :image_url => "google.com", :network => "NBC", :api_id => 35)
  #   u = User.new(:email => "q@q.com", :password => "password")
  #   u.skip_confirmation!
  #   expect(u.save).to be(true)
  #   get :post, {:channel_id => c.id, :user_id => u.id, :body => "sup"}
  #   expect(Message.find_by_body("sup")).not_to be_empty
  # end

  # it "user follow channel works" do
  #   c = Channel.create(:name => "Seinfeld", :image_url => "google.com", :network => "NBC", :api_id => 35)
  #   u = User.new(:email => "q@q.com", :password => "password")
  #   u.skip_confirmation!
  #   expect(u.save).to be(true)
  #   get :follow, {:channel_id => c.id, :user_id => u.id}
  #   expect(Favorites.find(:user_id => u.id, :channel_id => c.id)).not_to be_empty
  # end

  # it "user unfollow channel works" do
  #   c = Channel.create(:name => "Seinfeld", :image_url => "google.com", :network => "NBC", :api_id => 35)
  #   u = User.new(:email => "q@q.com", :password => "password")
  #   u.skip_confirmation!
  #   expect(u.save).to be(true)
  #   get :follow, {:channel_id => c.id, :user_id => u.id}
  #   expect(Favorites.find(:user_id => u.id, :channel_id => c.id)).not_to be_empty
  #   get :unfollow, {:channel_id => c.id, :user_id => u.id}
  #   expect(Favorites.find(:user_id => u.id, :channel_id => c.id)).to be_empty
  # end
end