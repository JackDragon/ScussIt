require 'spec_helper'
require 'rails_helper'

describe ChannelController do
  # before :each do
  # end
  # it "should make channel" do
  #   c = Channel.new(:name => "Seinfeld", :image_url => "google.com", :network => "NBC", :api_id => 35)
  #   expect(c.save).to be(true)
  # end

  # before { controller.stub(:authenticate_user!).and_return true }

  describe "channel GET index" do
    it "has a 200 status code" do
      get :index
      expect(response.status).to eq(200)
    end
  end

  it "channel post message" do
    c = Channel.create(:name => "Seinfeld", :image_url => "google.com", :network => "NBC", :api_id => 35)
    u = User.new(:email => "q@q.com", :password => "password")
    u.skip_confirmation!
    expect(u.save).to be(true)
    # get :post, {:id => c.id, :channel_id => c.id, :user_id => u.id, :body => "sup"}
    post :post, {:id => c.id, :channel_id => c.id, :user_id => u.id, :body => "sup"}
    expect(Message.find_by_body("sup")).not_to be_empty
  end

  it "user follow channel works" do
    c = Channel.create(:name => "Seinfeld", :image_url => "google.com", :network => "NBC", :api_id => 35)
    u = User.new(:email => "q@q.com", :password => "password")
    u.skip_confirmation!
    expect(u.save).to be(true)
    post :follow, {:channel_id => c.id, :user_id => u.id}
    # post "follow", {:channel_id => c.id, :user_id => u.id}
    # expect(Favorite.find(:user_id => u.id, :channel_id => c.id)).not_to be_empty
    expect(Favorite.where(:user_id => u.id, :channel_id => c.id)).not_to be_empty
  end

  it "user unfollow channel works" do
    c = Channel.create(:name => "Seinfeld", :image_url => "google.com", :network => "NBC", :api_id => 35)
    u = User.new(:email => "q@q.com", :password => "password")
    u.skip_confirmation!
    expect(u.save).to be(true)
    post :follow, {:channel_id => c.id, :user_id => u.id}, :id => c.id
    expect(Favorite.where(:user_id => u.id, :channel_id => c.id)).not_to be_empty
    post :unfollow, {:channel_id => c.id, :user_id => u.id}, :id => c.id
    expect(Favorite.where(:user_id => u.id, :channel_id => c.id)).to be_empty
  end
end