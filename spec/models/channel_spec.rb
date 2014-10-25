require 'spec_helper'
require 'rails_helper'


describe Channel do
  it "should make channel" do
    c = Channel.new(:name => "Seinfeld", :image_url => "google.com", :network => "NBC", :api_id => 35)
    expect(c.save).to be(true)
  end

  it "should fail channel" do
    c = Channel.new(:image_url => "google.com")
    expect(c.save).to be(false)
  end

  it "should fail channel unique id" do
    c = Channel.new(:name => "Seinfeld", :image_url => "google.com", :network => "NBC", :api_id => 35)
    expect(c.save).to be(true)
    c = Channel.new(:name => "Friends", :image_url => "google.com", :network => "NBC", :api_id => 35)
    expect(c.save).to be(false)
  end

  context 'getting messages' do
    it 'should return the messages for the channel' do    
      c = Channel.create(:name => "Seinfeld", :image_url => "google.com", :network => "NBC", :api_id => 35)
      u = User.new(:email => "q@q.com", :password => "password", username: 'joe')
      u.skip_confirmation!
      u.save!
      Message.create!(user_id: u.id, channel_id: c.id, body: 'huh, does this work?')
      expect(Channel.get_messages(c.id)).to eq [{user: 'joe', body: 'huh, does this work?'}]
    end
  end
end