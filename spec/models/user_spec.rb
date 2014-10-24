require 'spec_helper'
require 'rails_helper'

describe User do
    # before :each do
    # end

    it "should not save user" do
      u = User.new(email: "jackrlong@yahoo.com")
      expect(u.save).to be(false)
    end

    # describe "valid user make and sign in", :type => :feature do
    #   before :each do
    #     User.make(:email => 'q@qq.com', :password => 'password')
    #   end
    #
    #   it "signs me in" do
    #     visit '/users/sign_in'
    #     within("#new_user") do
    #       fill_in 'user_email', :with => 'q@qq.com'
    #       fill_in 'user_password', :with => 'password'
    #     end
    #     click_button 'commit'
    #     expect(page).to have_content 'Logged in as'
    #   end
    # end
end