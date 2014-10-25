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
  describe "Message posting" do
    include Devise::TestHelpers
    # @request.env["devise.mapping"] = Devise.mappings[:user]
    it "channel post message" do
      c = Channel.create(:name => "Seinfeld", :image_url => "google.com", :network => "NBC", :api_id => 35)
      u = User.create!(:email => "q@q.com", :password => "password", password_confirmation: 'password', username: 'joejoe')
      sign_in u
      # get :post, {:id => c.id, :channel_id => c.id, :user_id => u.id, :body => "sup"}
      post :post, {:id => c.id, :channel_id => c.id, :body => "sup"}
      expect(response.body).to eq "{success: 1}"
      #expect(Message.find_by_body("sup")).not_to be_empty
    end
  end

  it "user follow channel works" do
    c = Channel.create(:name => "Seinfeld", :image_url => "google.com", :network => "NBC", :api_id => 35)
    u = User.create!(:email => "q@q.com", :password => "password", password_confirmation: 'password', username: 'joejoe')

    sign_in u
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



  describe 'GET #find' do
    context 'when a room doesn\'t exist' do
      it 'creates a new room and redirects to it' do
        get :find, {api_id: 123, name: 'datshow'}
        expect(response).to redirect_to("/channel/#{assigns(:channel).id}")
      end
    end

    context 'when a room does exist, ' do
      it 'just redirects to it' do    
        c = Channel.create(:name => "Seinfeld", :image_url => "google.com", :network => "NBC", :api_id => 35)
        get :find, {api_id: 35}
        expect(response).to redirect_to("/channel/#{c.id}")
      end
    end
  end

  describe 'GET #room' do
    context 'user goes to a chatroom' do
      it 'renders the index page' do
        c = Channel.create(:name => "Seinfeld", :image_url => "google.com", :network => "NBC", :api_id => 35)
        get :room, {id: c.id}
        expect(response).to render_template(:index)
      end
    end

    context 'when a room does exist, ' do
      it 'just redirects to it' do    
        c = Channel.create(:name => "Seinfeld", :image_url => "google.com", :network => "NBC", :api_id => 35)
        get :find, {api_id: 35}
        expect(response).to redirect_to("/channel/#{c.id}")
      end
    end
  end



end