require 'spec_helper'
# == Schema Information
#
# Table name: messages
#
#  id            :integer          not null, primary key
#  body          :string(255)
#  creation_time :datetime
#  created_at    :datetime
#  updated_at    :datetime
#  user_id       :integer
#  channel_id    :integer
#
require 'rails_helper'

describe Message do
  it "should make message" do
    c = Channel.create(:name => "Seinfeld", :image_url => "google.com", :network => "NBC", :api_id => 35)
    u = User.new(:email => "q@q.com", :password => "password")
    u.skip_confirmation!
    expect(u.save).to be(true)
    m = Message.new(:body => "trololol", :user_id => u.id, :channel_id => c.id)
    expect(m.save).to be(true)
  end

  it "should fail make message no uid" do
    c = Channel.create(:name => "Seinfeld", :image_url => "google.com", :network => "NBC", :api_id => 35)
    u = User.new(:email => "q@q.com", :password => "password")
    u.skip_confirmation!
    expect(u.save).to be(true)
    m = Message.new(:body => "trololol", :channel_id => c.id)
    expect(m.save).to be(false)
  end

  it "should fail make message no body" do
    c = Channel.create(:name => "Seinfeld", :image_url => "google.com", :network => "NBC", :api_id => 35)
    u = User.new(:email => "q@q.com", :password => "password")
    u.skip_confirmation!
    expect(u.save).to be(true)
    m = Message.new(:channel_id => c.id, :user_id => u.id)
    expect(m.save).to be(false)
  end

  it "should fail channel no cid" do
    c = Channel.create(:name => "Seinfeld", :image_url => "google.com", :network => "NBC", :api_id => 35)
    u = User.new(:email => "q@q.com", :password => "password")
    u.skip_confirmation!
    expect(u.save).to be(true)
    m = Message.new(:body => "trololol", :user_id => u.id)
    expect(m.save).to be(false)
  end

  it "should not fail same channel multiple messages" do
    c = Channel.create(:name => "Seinfeld", :image_url => "google.com", :network => "NBC", :api_id => 35)
    u = User.new(:email => "q@q.com", :password => "password")
    u.skip_confirmation!
    expect(u.save).to be(true)
    m = Message.new(:body => "trololol", :user_id => u.id, :channel_id => c.id)
    expect(m.save).to be(true)
    m = Message.new(:body => "trololol", :user_id => u.id, :channel_id => c.id)
    expect(m.save).to be(true)
  end
end
