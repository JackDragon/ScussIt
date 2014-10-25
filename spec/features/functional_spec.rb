require 'spec_helper'
require 'rails_helper'

describe ChannelController do
  describe "the signin process", :type => :feature do
    before :each do
      u = User.new(:email => 'q@q.q', :password => 'password', password_confirmation: 'password', username: 'qqq')
      u.skip_confirmation!
      u.save!
    end

    it "signs me in" do
      visit '/users/sign_in'
      within("#new_user") do
        fill_in 'Email', :with => 'q@q.q'
        fill_in 'Password', :with => 'password'
      end
      click_button 'Log in'
      expect(page).to have_content 'q@q.q'
    end
  end

  describe "user routes", :type => :feature do
    before :each do
      u = User.new(:email => 'q@q.q', :password => 'password', password_confirmation: 'password', username: 'qqq')
      u.skip_confirmation!
      u.save!
      visit '/users/sign_in'
      within("#new_user") do
        fill_in 'Email', :with => 'q@q.q'
        fill_in 'Password', :with => 'password'
      end
      click_button 'Log in'
    end

  it "goes to a chatroom" do
    c = Channel.create!(:name => "Seinfeld", :image_url => "google.com", :network => "NBC", :api_id => 35)
    visit(channel_room_path(c))
    expect(page).to have_content 'Seinfeld'
  end

  it "posts a message in the chat" do
    c = Channel.create!(:name => "Seinfeld", :image_url => "google.com", :network => "NBC", :api_id => 35)
    visit(channel_room_path(c))
    fill_in 'message_input', with: 'HIII WORLD'
    click_button 'send_button'
    visit(channel_room_path(c))
    expect(page).to have_content 'HIII WORLD'
  end

  it "tries to follow a channel" do
    c = Channel.create!(:name => "Seinfeld", :image_url => "google.com", :network => "NBC", :api_id => 35)
    visit(channel_room_path(c))
    click_button "#{c.api_id}"
    # page.find('btn.btn-primary.follow').click
    # expect(page).to have_content 'Unfollow'
    expect(page.has_content?('Unfollow')).to be_true
  end

  it "visits the browse page" do
    visit('/browse')
    expect(page).to have_css('div.browse_wrapper')
  end

  it "tries to click on a page on the front page" do
    visit('/')

  end

  it "tries to click on a page on the browse page" do
  end

  it "tries to follow a page from the browse page" do
  end

  it "tries to log out" do
  end

  it "tries to change its information, then logs out, then tries to login with new information" do

  end

end


end