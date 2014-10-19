require 'spec_helper'
require 'rails_helper'

describe User do
    # before :each do
    # end

    it "should not fail user save" do
      u = User.new(email: "jackrlong@yahoo.com")
      expect(u.save).to be_valid
    end
end