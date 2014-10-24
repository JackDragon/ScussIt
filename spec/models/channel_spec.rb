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
end