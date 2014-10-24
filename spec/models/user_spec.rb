require 'spec_helper'
require 'rails_helper'

describe User do
    # before :each do
    # end

    it "is valid User" do
      u = User.new(email: "jon.lo@berkeley.edu", password: "123")
      expect(u.save).to be_valid
    end

    it "password cannot be empty?" do
      u = User.new(email: "jackrlong@yahoo.com")
      expect(u.save).not_to be_valid
    end

end