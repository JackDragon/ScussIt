class ChangeChannelUniqueApiId < ActiveRecord::Migration
  def change
    add_index(:channels, :api_id, :unique => true)
  end
end
