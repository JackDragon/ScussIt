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
    show = JSON.parse('{"backdrop_path":"/3yLECa8OqWys9yl7vE53apjoDsO.jpg","id": 4385,"original_name":"The Colbert Report","first_air_date":"2005-10-17","origin_country":["US"],"poster_path":"/7mwErPneNN2BUAODW2gldnhL8Oe.jpg","popularity":1.88902176650493,"name":"The Colbert Report","vote_average":8.0,"vote_count":2,"networks": [{"id": 88,"name": "FX"}]}')
    j = Channel.parse_detail(show)
    
    expect(j[:id]).to eq(4385)
    expect(j[:name]).to eq("The Colbert Report")
    expect(j[:poster_path]).to eq('/7mwErPneNN2BUAODW2gldnhL8Oe.jpg')
  end

  it "should follow correctly" do
    c = Channel.create(:name => "Seinfeld", :image_url => "google.com", :network => "NBC", :api_id => 35)
    u = User.new(:email => "q@q.com", :password => "password", username: 'joe')
    u.skip_confirmation!
    u.save!
    params = {:cid => c.id}
    Channel.follow(params, u, nil)
    fav = Favorite.where(:user_id => u.id, :channel_id => c.id)
    expect(fav.empty?).to be(false)
  end

  it "should follow correctly api_id and get correct following method" do
    c = Channel.create(:name => "Seinfeld", :image_url => "google.com", :network => "NBC", :api_id => "35")
    u = User.new(:email => "q@q.com", :password => "password", username: 'joe')
    u.skip_confirmation!
    u.save!
    params = {:api_id => c.api_id}
    Channel.follow(params, u, nil)
    fav = Favorite.where(:user_id => u.id, :channel_id => c.id)
    expect(fav.empty?).to be(false)
    params = {:id => c.api_id}
    following = Channel.following(params, u)
    expect(following).to be(true)
  end

  it "should unfollow correctly" do
    c = Channel.create(:name => "Seinfeld", :image_url => "google.com", :network => "NBC", :api_id => 35)
    u = User.new(:email => "q@q.com", :password => "password", username: 'joe')
    u.skip_confirmation!
    u.save!
    params = {:cid => c.id}
    Channel.follow(params, u, nil)
    fav = Favorite.where(:user_id => u.id, :channel_id => c.id)
    expect(fav.empty?).to be(false)
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
    expect(act.empty?).to be(false)
  end

  it "should correctly add to active user list and update" do
    c = Channel.create(:name => "Seinfeld", :image_url => "google.com", :network => "NBC", :api_id => 35)
    u = User.new(:email => "q@q.com", :password => "password", username: 'joe')
    u.skip_confirmation!
    u.save!
    params = {:cid => c.id.to_i}
    Channel.active_add(params, u)
    act = Active.where(:user_id => u.id, :channel_id => c.id)
    expect(act.empty?).to be(false)
    before = act[0].updated
    Channel.active_update(params, u)
    act = Active.where(:user_id => u.id, :channel_id => c.id)
    expect(act.empty?).to be(false)
    after = act[0].updated
    expect(after >= before).to be(true)
  end

  it "should correctly add to active user list and delete" do
    c = Channel.create(:name => "Seinfeld", :image_url => "google.com", :network => "NBC", :api_id => 35)
    u = User.new(:email => "q@q.com", :password => "password", username: 'joe')
    u.skip_confirmation!
    u.save!
    params = {:cid => c.id}
    Channel.active_add(params, u)
    act = Active.where(:user_id => u.id, :channel_id => c.id)
    expect(act.empty?).to be(false)
    Channel.active_delete(params, u)
    act = Active.where(:user_id => u.id, :channel_id => c.id)
    expect(act).to eq([])
  end

  context 'getting messages' do
    it 'should return the messages for the channel' do    
      c = Channel.create(:name => "Seinfeld", :image_url => "google.com", :network => "NBC", :api_id => 35)
      u = User.new(:email => "q@q.com", :password => "password", username: 'joe')
      u.skip_confirmation!
      u.save!
      Message.create!(user_id: u.id, channel_id: c.id, body: 'huh, does this work?')
      expect(Channel.get_messages(c.id)).to eq [{user: 'joe', body: 'huh, does this work?', id: 4}]
    end
  end

  ### Topics ###
  it 'should create main topic by default works' do
    c = Channel.create(:name => "Seinfeld", :image_url => "google.com", :network => "NBC", :api_id => 35)
    expect(Topic.find_by(channel_id: c.id, name: "Main")).to_not be(nil)
  end
  
  it 'should create new topic works' do
    c = Channel.create(:name => "Seinfeld", :image_url => "google.com", :network => "NBC", :api_id => 35)
    t = c.topics.create(:name => "awesome")
    expect(Topic.find_by(channel_id: c.id, name: "awesome")).to_not be(nil)
  end

  it 'should create new topic and message and they both link with each other' do
    c = Channel.create(:name => "Seinfeld", :image_url => "google.com", :network => "NBC", :api_id => 35)
    t = c.topics.create(:name => "awesome")
    expect(Topic.find_by(channel_id: c.id, name: "awesome")).to_not be(nil)
    u = User.new(:email => "q@q.com", :password => "password", username: 'joe')
    u.skip_confirmation!
    u.save!
    m = Message.create!(user_id: u.id, channel_id: c.id, body: '#awesome does this work?', topic_id: t.id)
    expect(m.topic.name).to eq("awesome")
  end

  it 'should return correct active' do
    c = Channel.create(:name => "Seinfeld", :image_url => "google.com", :network => "NBC", :api_id => 35)
    t = c.topics.create(:name => "awesome")
    expect(Topic.find_by(channel_id: c.id, name: "awesome")).to_not be(nil)
    u = User.new(:email => "q@q.com", :password => "password", username: 'joe')
    u.skip_confirmation!
    u.save!
    a = c.actives.create(user_id: u.id, updated: DateTime.now)
    expect(Active.where(:channel_id => c.id).where("updated > ?", DateTime.now-5.seconds)).to_not be_empty
  end

  it 'should return correct active user list' do
    c = Channel.create(:name => "Seinfeld", :image_url => "google.com", :network => "NBC", :api_id => 35)
    t = c.topics.create(:name => "awesome")
    expect(Topic.find_by(channel_id: c.id, name: "awesome")).to_not be(nil)
    u = User.new(:email => "q@q.com", :password => "password", username: 'joe')
    u.skip_confirmation!
    u.save!
    a = c.actives.create(user_id: u.id, updated: DateTime.now)
    expect(Active.where(:channel_id => c.id).where("updated > ?", DateTime.now-5.seconds)).to_not be_empty
    userlist = Channel.active_user_list({id: c.id}, u)
    expect(userlist).to eq(['joe'])
  end

  it 'should create topic using channel controller' do
    c = Channel.create(:name => "Seinfeld", :image_url => "google.com", :network => "NBC", :api_id => 35)
    u = User.new(:email => "q@q.com", :password => "password", username: 'joe')
    u.skip_confirmation!
    t = c.create_topic(:name => "awesome")
    expect(Topic.find_by(channel_id: c.id, name: "awesome")).to_not be(nil)
  end

  it 'should get correct message list for topic' do
    c = Channel.create(:name => "Seinfeld", :image_url => "google.com", :network => "NBC", :api_id => 35)
    u = User.new(:email => "q@q.com", :password => "password", username: 'joe')
    u.skip_confirmation!
    t = c.create_topic(:name => "awesome")
    u.save!
    Message.create!(user_id: u.id, channel_id: c.id, body: '#awesome yo', topic_id: t.id)
    expect(Channel.get_messages_for_topic(c.id, "awesome")).to eq [{user: 'joe', body: '#awesome yo', id: 3}]
  end

  # it 'should get all users for channel' do
  #   c = Channel.create(:name => "Seinfeld", :image_url => "google.com", :network => "NBC", :api_id => 35)
  #   t = c.topics.create(:name => "awesome")
  #   expect(Topic.find_by(channel_id: c.id, name: "awesome")).to_not be(nil)
  #   u = User.new(:email => "q@q.com", :password => "password", username: 'joe')
  #   u.skip_confirmation!
  #   u.save!
  #   a = c.actives.create(user_id: u.id, updated: DateTime.now)
  #   expect(Active.where(:channel_id => c.id).where("updated > ?", DateTime.now-5.seconds)).to_not be_empty
  #   userlist = c.get_users()
  #   expect(userlist).to_be not_empty
  # end

  it 'should get right no user count' do
    c = Channel.create(:name => "Seinfeld", :image_url => "google.com", :network => "NBC", :api_id => 35)
    count = c.get_user_count(c.id, "Main")
    expect(count).to eq 0
  end

  it 'should get right user count' do
    c = Channel.create(:name => "Seinfeld", :image_url => "google.com", :network => "NBC", :api_id => 35)
    t = c.topics.create(:name => "awesome")
    expect(Topic.find_by(channel_id: c.id, name: "awesome")).to_not be(nil)
    u = User.new(:email => "q@q.com", :password => "password", username: 'joe')
    u.skip_confirmation!
    u.save!
    a = c.actives.create(user_id: u.id, updated: DateTime.now)
    expect(Active.where(:channel_id => c.id).where("updated > ?", DateTime.now-5.seconds)).to_not be_empty
    count = c.get_user_count(c.id, "Main")
    expect(count).to eq 1
  end
end