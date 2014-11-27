class DdLastMessageToChannel < ActiveRecord::Migration
  def change
    add_column :channels, :last_message, :datetime
  end
end
