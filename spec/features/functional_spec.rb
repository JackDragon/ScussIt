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
    expect(find())
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
    visit('/users/sign_out')
    expect(page).to have_content 'Login'
  end

  it "tries to change its information, then logs out" do
    visit('/users/edit')
    fill_in 'user[email]', with: "jackrlong@yahoo.com"
    fill_in 'user[current_password]', with: "password"
    click_button "Update"
    expect(page).to have_content 'jackrlong@yahoo.com'
    visit('/users/sign_out')
    expect(page).to have_content 'Login'
  end

  it "tries to change its information, then then login with new information" do
    visit('/users/edit')
    fill_in 'user[email]', with: "jackrlong@yahoo.com"
    fill_in 'user[current_password]', with: "password"
    click_button "Update"
    expect(page).to have_content 'jackrlong@yahoo.com'
    visit('/users/sign_out')
    expect(page).to have_content 'Login'
    visit '/users/sign_in'
    within("#new_user") do
      fill_in 'Email', :with => 'jackrlong@yahoo.com'
      fill_in 'Password', :with => 'password'
    end
    click_button 'Log in'
    expect(page).to have_content 'jackrlong@yahoo.com'
  end

end


end