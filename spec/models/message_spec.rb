require 'spec_helper'
require 'rails_helper'

describe Message do
  before :each do
  end

  it "should make message" do
    c = Channel.create(:name => "Seinfeld", :image_url => "google.com", :network => "NBC", :api_id => 35)
    u = User.create(:email => "q@q.com", :password => "password")
    m = Message.new(:body => "trololol", :user_id => u.id, :channel_id => c.id)
    expect(m.save).to be(true)
  end

  it "should fail make message no uid" do
    c = Channel.create(:name => "Seinfeld", :image_url => "google.com", :network => "NBC", :api_id => 35)
    u = User.create(:email => "q@q.com", :password => "password")
    m = Message.new(:body => "trololol", :channel_id => c.id)
    expect(m.save).to be(false)
  end

  it "should fail make message no body" do
    c = Channel.create(:name => "Seinfeld", :image_url => "google.com", :network => "NBC", :api_id => 35)
    u = User.create(:email => "q@q.com", :password => "password")
    m = Message.new(:channel_id => c.id, :user_id => u.id)
    expect(m.save).to be(false)
  end

  it "should fail channel no cid" do
    c = Channel.create(:name => "Seinfeld", :image_url => "google.com", :network => "NBC", :api_id => 35)
    u = User.create(:email => "q@q.com", :password => "password")
    m = Message.new(:body => "trololol", :user_id => u.id)
    expect(m.save).to be(false)
  end

  it "should not fail same channel multiple messages" do
    c = Channel.create(:name => "Seinfeld", :image_url => "google.com", :network => "NBC", :api_id => 35)
    u = User.create(:email => "q@q.com", :password => "password")
    m = Message.new(:body => "trololol", :user_id => u.id, :channel_id => c.id)
    expect(m.save).to be(true)
    m = Message.new(:body => "trololol", :user_id => u.id, :channel_id => c.id)
    expect(m.save).to be(true)
  end
end
