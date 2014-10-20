class ChannelPictureUpdate < ActiveRecord::Migration
  def change
    add_column(:channels, :image_url, :string)
    add_column(:channels, :network, :string)
    add_column(:channels, :api_id, :string)
  end
end
