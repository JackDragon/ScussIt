# Bryant Chang
# Renjie Long
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
    fill_in 'message_input', with: 'Scuss'
    click_button 'send_button'
    expect(page).to have_content 'Scuss'
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

  describe "user routes", :type => :feature do
    before :each do
      u = User.new(:email => 'q@q.q', :password => 'password', password_confirmation: 'password', username: 'qqq')
      u.skip_confirmation!
      u.save!
      c = Channel.create!(:name => "Gilmore Girls", :image_url => "google.com", :network => "NBC", :api_id => 35)
      visit '/users/sign_in'
      within("#new_user") do
        fill_in 'Email', :with => 'q@q.q'
        fill_in 'Password', :with => 'password'
      end
      click_button 'Log in'
    end

  it "channel post message", :js => true do
    c = Channel.where(:name => "Gilmore Girls")
    visit(channel_room_path(c))
    expect(page).to have_content 'Gilmore Girls'
    fill_in 'message_input', :with => 'I LOVE Gilmore Girls'
    click_button '.send_button'
    expect(page).to have_content 'I LOVE Gilmore Girls'
    fill_in 'message_input', :with => 'Like OMG RORY IS TOO GOOD FOR HIM'
    click_button '.send_button'
    fill_in 'message_input', :with => 'GOD MAX IS A PRICK'
    click_button '.send_button'

    expect(page).to have_content 'I LOVE Gilmore Girls'
    expect(page).to have_content 'Like OMG RORY IS TOO GOOD FOR HIM'
    expect(page).to have_content 'GOD MAX IS A PRICK'
  end

  it "goes to channel from frontpage", :js => true do
    visit '/'
    find("img[@alt='']").click
    expect(page).to have_content 'Main:'
  end

  it "favorites on the channel page", :js => true do
    # c = Channel.create!(:name => "Gilmore Girls", :image_url => "google.com", :network => "NBC", :api_id => 35)
    c = Channel.where(:name => "Gilmore Girls")
    visit(channel_room_path(c))
    expect(page).to have_content 'Gilmore Girls'

    expect(page).to have_content 'Follow'
    click_button '#follow'
    expect(page).to have_content 'Unfollow'
  end


  it "favorites a channel from the browse page", :js => true do
    visit '/browse'
    find("img[@alt='']").click
    expect(page).to have_content 'Follow'
    click_button '#follow'
    expect(page).to have_content 'Unfollow'
  end


  it "logs out and checks for a favorites button on the channel page", :js => true do
    visit('/users/sign_out')
    visit '/'
    find("img[@alt='']").click
    expect(page).to_not have_content 'Follow'
  end


  it "shows the user on the userlist page", :js => true do
    visit('/channel/active/1')
    expect(page).to have_content 'qqq'
  end

  it "doesn't show the user on the userlist page if not logged in", :js => true do
    visit('/users/sign_out')
    visit('/channel/active/1')
    expect(page).to_not have_content 'qqq'
  end

end