# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#

require 'spec_helper'
require 'rails_helper'

describe User do
    # before :each do
    # end

    context "presence tests" do

	    context "with no e-mail" do

	    	before do
	    		@user = User.new(password: "abcdefgh")
	    	end

	    	it "has only password with confirmation" do
	    		@user.skip_confirmation!
	    		expect(@user.save).to be(false)
	    	end

	    	it "has username and password with confirmation" do
	    		@user.username = "test"
	    		@user.skip_confirmation!
	    		expect(@user.save).to be(false)
	    	end

	    	it "has username and password without confirmation" do
	    		@user.username = "test"
	    		expect(@user.save).to be(false)
	    	end
	    end

	    context "with e-mail" do

	    	before do
	    		@user = User.new(email: "rspec@test.com")
	    	end

	    	it "only" do
	    		expect(@user.save).to be(false)
	    	end

	    	it ", username, and password with confirmation" do
	    		@user.username = "test"
	    		@user.password = "!!!!!!!!"
	    		@user.skip_confirmation!
	    		expect(@user.save).to be(true)
	    	end

	    	it ", username, and password with confirmation" do
	    		@user.username = "test"
	    		@user.password = "!!!!!!!!"
	    		@user.skip_confirmation!
	    		expect(@user.save).to be(true)
	    	end

	    	it "and password with confirmation" do
	    		@user.password = "!!!!!!!!"
	    		@user.skip_confirmation!
	    		expect(@user.save).to be(true)
	    	end

	    	# it "and password no confirmation" do
	    	# 	@user.password = "!!!!!!!!"
	    	# 	expect(@user.save).to be(false)
	    	# end

	    end
	end

    # context "length tests" do

    # end
 	#    describe "follow channel" do
	#     context "User rspec@test.com" do
	#     	before do
	#     		@user = User.new(email: "rspec@test.com")
	#     		@user.save
	#     	end

	#     	# context "cid:"
	#     end
	# end

    it "is valid User" do
      u = User.new(email: "jon.lo@berkeley.edu", password: "12345678")
      u.username = "jlo"
      u.skip_confirmation!
      expect(u.save).to be(true)
    end

    it "password cannot be empty" do
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
