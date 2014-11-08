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

  it "should parse show details properly" do 
    show = JSON.parse('{"backdrop_path":"/3yLECa8OqWys9yl7vE53apjoDsO.jpg","id":4385,"original_name":"The Colbert Report","first_air_date":"2005-10-17","origin_country":["US"],"poster_path":"/7mwErPneNN2BUAODW2gldnhL8Oe.jpg","popularity":1.88902176650493,"name":"The Colbert Report","vote_average":8.0,"vote_count":2}')
    j = Channel.parse_detail(show)
    expect(j['id']).to eq(4385)
    expect(j['name']).to eq("The Colbert Report")
    expect(j['poster_path']).to eq('/7mwErPneNN2BUAODW2gldnhL8Oe.jpg')
  end

  it "should follow correctly" do
    c = Channel.create(:name => "Seinfeld", :image_url => "google.com", :network => "NBC", :api_id => 35)
    u = User.new(:email => "q@q.com", :password => "password", username: 'joe')
    u.skip_confirmation!
    u.save!
    params = {:cid => c.id}
    Channel.follow(params, u)
    fav = Favorite.where(:user_id => u.id, :channel_id => c.id)
    expect(fav.nil?).to be(false)
  end

  it "should follow correctly api_id and get correct following method" do
    c = Channel.create(:name => "Seinfeld", :image_url => "google.com", :network => "NBC", :api_id => 35)
    u = User.new(:email => "q@q.com", :password => "password", username: 'joe')
    u.skip_confirmation!
    u.save!
    params = {:api_id => c.api_id}
    Channel.follow(params, u)
    fav = Favorite.where(:user_id => u.id, :channel_id => c.id)
    expect(fav.nil?).to be(false)
    params = {:id => c.id}
    following = Channel.following(params, u)
    expect(following).to be(true)
  end

  it "should unfollow correctly" do
    c = Channel.create(:name => "Seinfeld", :image_url => "google.com", :network => "NBC", :api_id => 35)
    u = User.new(:email => "q@q.com", :password => "password", username: 'joe')
    u.skip_confirmation!
    u.save!
    params = {:cid => c.id}
    Channel.follow(params, u)
    fav = Favorite.where(:user_id => u.id, :channel_id => c.id)
    expect(fav.nil?).to be(false)
    Channel.unfollow(params, u)
    fav = Favorite.where(:user_id => u.id, :channel_id => c.id)
    expect(fav).to eq([])
  end

  it "should correctly add to active user list" do
    c = Channel.create(:name => "Seinfeld", :image_url => "google.com", :network => "NBC", :api_id => 35)
    u = User.new(:email => "q@q.com", :password => "password", username: 'joe')
    u.skip_confirmation!
    u.save!
    params = {:cid => c.id}
    Channel.active_add(params, u)
    act = Active.where(:user_id => u.id, :channel_id => c.id)
    expect(fav.nil?).to be(false)
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