# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user = User.new :username => 'John Doe', :email => 'johndoe@seed.com', :password => 'sekret00', :password_confirmation => 'sekret00'
user.skip_confirmation!
user.save
user = User.new :username => 'John Moe', :email => 'johnmoe@seed.com', :password => 'sekret01', :password_confirmation => 'sekret01'
user.skip_confirmation!
user.save
user = User.new :username => 'John Boe', :email => 'johnboe@seed.com', :password => 'sekret02', :password_confirmation => 'sekret02'
user.skip_confirmation!
user.save
user = User.new :username => 'John Soe', :email => 'johnsoe@seed.com', :password => 'sekret03', :password_confirmation => 'sekret03'
user.skip_confirmation!
user.save
user = User.new :username => 'asd', :email => 'asd@seed.com', :password => 'asdasdasd', :password_confirmation => 'asdasdasd'
user.skip_confirmation!
user.save
user = User.new :username => 'qqq', :email => 'q@q.q', :password => 'qqqqqqqq', :password_confirmation => 'qqqqqqqq'
user.skip_confirmation!
user.save

channel = Channel.create! :name => 'whee', :api_id => 34
channel = Channel.create! :name => 'bee', :api_id => 35
channel = Channel.create! :name => 'teehee?', :api_id => 31

message = Message.create! body: 'huh, does this work?', user_id: 1, channel_id: 1