# This is a test file for channel controller
# Bryant Chang
# Renjie Long
# Jonathan Lo
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
  # 
  describe "Set total page" do
    it "returns total page" do
      @controller = ChannelController.new
      @controller.instance_eval{set_total_page(3)}
      total = @controller.instance_eval{get_total_page()}
      expect(total).to eq(3)
    end
  end

  describe "Set current page" do
    it "returns current page" do
      @controller = ChannelController.new
      @controller.instance_eval{set_current_page(3)}
      current = @controller.instance_eval{get_current_page()}
      expect(current).to eq(3)
    end
  end


  describe "update active in channel.rb" do
    it "return new time for Active" do
      @controller = ChannelController.new
      
      u = User.new(:email => "q@q.com", :password => "password", username: 'joe')
      c = Channel.create(:name => "Seinfeld", :image_url => "google.com", :network => "NBC", :api_id => 60743)
      entry_1 = Active.new(channel_id: c.id, user_id: u.id, updated: DateTime.now)
      post :update_active, cid: c.id
      entry_2 = Active.find_by(channel_id: c.id, user_id: u.id)
      
      expect(entry_1).to_not eq(entry_2)
    end
  end

  describe "click next page" do
    it "increment current page" do
      @controller = ChannelController.new
      @controller.instance_eval{set_total_page(3)}
      @controller.instance_eval{set_current_page(1)}
      
      get :next_page
      current = @controller.instance_eval{get_current_page()}
      expect(current).to eq(2)
    end
  end

  describe "click previous page" do
    it "decrement current page" do
      @controller = ChannelController.new
      @controller.instance_eval{set_total_page(5)}
      @controller.instance_eval{set_current_page(4)}
      
      get :previous_page
      current = @controller.instance_eval{get_current_page()}
      expect(current).to eq(3)
    end
  end


  describe "channel GET index" do
    it "has a 200 status code" do
      get :index
      expect(response.status).to eq(200)
    end
  end

  # describe "Message posting" do
  #   include Devise::TestHelpers
  #   # @request.env["devise.mapping"] = Devise.mappings[:user]
  #   it "channel post message" do
  #     c = Channel.create(:name => "Seinfeld", :image_url => "google.com", :network => "NBC", :api_id => 35)
  #     u = User.create!(:email => "q@q.com", :password => "password", password_confirmation: 'password', username: 'joejoe')
  #     sign_in u
  #     # get :post, {:id => c.id, :channel_id => c.id, :user_id => u.id, :body => "sup"}
  #     post :post, {:id => c.id, :channel_id => c.id, :body => "sup"}
  #     expect(response.body).to eq "{success: 1}"
  #     #expect(Message.find_by_body("sup")).not_to be_empty
  #   end
  # end

  # it "user follow channel works" do
  #   c = Channel.create(:name => "Seinfeld", :image_url => "google.com", :network => "NBC", :api_id => 35)
  #   u = User.create!(:email => "q@q.com", :password => "password", password_confirmation: 'password', username: 'joejoe')

  #         u = User.new(:email => 'q@q.q', :password => 'password', password_confirmation: 'password', username: 'qqq')
  #     u.skip_confirmation!
  #     u.save!
  #     visit '/users/sign_in'
  #     within("#new_user") do
  #       fill_in 'Email', :with => 'q@q.q'
  #       fill_in 'Password', :with => 'password'
  #   post :follow, {:channel_id => c.id, :user_id => u.id}
  #   # post "follow", {:channel_id => c.id, :user_id => u.id}
  #   # expect(Favorite.find(:user_id => u.id, :channel_id => c.id)).not_to be_empty
  #   expect(Favorite.where(:user_id => u.id, :channel_id => c.id)).not_to be_empty
  # end

  # it "user unfollow channel works" do
  #   c = Channel.create(:name => "Seinfeld", :image_url => "google.com", :network => "NBC", :api_id => 35)
  #   u = User.new(:email => "q@q.com", :password => "password")
  #   u.skip_confirmation!
  #   expect(u.save).to be(true)
  #   post :follow, {:channel_id => c.id, :user_id => u.id}, :id => c.id
  #   expect(Favorite.where(:user_id => u.id, :channel_id => c.id)).not_to be_empty
  #   post :unfollow, {:channel_id => c.id, :user_id => u.id}, :id => c.id
  #   expect(Favorite.where(:user_id => u.id, :channel_id => c.id)).to be_empty
  # end



  describe 'GET #find' do
    context 'when a room doesn\'t exist' do
      it 'creates a new room and redirects to it' do
        get :find, {api_id: 123, name: 'datshow'}
        expect(response.status).to eq(200)
      end
    end

    context 'when a room does exist, ' do
      it 'just redirects to it' do    
        c = Channel.create(:name => "Seinfeld", :image_url => "google.com", :network => "NBC", :api_id => 35)
        get :find, {api_id: 35}
        expect(response.status).to eq(200)
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
        expect(response.status).to eq(200)
      end
    end
  end

  # describe 'post #post' do
  #   context 'we post a message in a row' do
  #     it 'should have the message show up' do
  #       Channel.create(:name => "Seinfeld", :image_url => "google.com", :network => "NBC", :api_id => 35)
  #       post :post, {body: "test", channel_id: 1}
  #
  #       expect(Messages.where(channel_id: 1).body).to eq("test")
  #     end
  #   end
  # end



end