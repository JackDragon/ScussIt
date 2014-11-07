require 'rails_helper'
require 'spec_helper'

RSpec.describe User do
  #it "has a valid factory" do
  #  Factory.create(:contact).should be_valid
  #end

  it "is invalid without a username" do
    expect(User.create(username: nil, password: "12345678")).to_not be_valid
  end

  it "is invalid if same username" do
    expect(User.create(username: "Joe", password: "12345678")).to be_valid
    expect(User.create(username: "Joe", password: "12345678")).to_not be_valid
  end

  it "is invalid if username is too long" do
    name = "blabla"*30
    expect(User.create(username: name, password: "12345678")).to_not be_valid
  end

end