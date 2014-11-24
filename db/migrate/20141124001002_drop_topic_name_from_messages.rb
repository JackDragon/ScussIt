class DropTopicNameFromMessages < ActiveRecord::Migration
  def change
    remove_column :messages, :topic_name
  end
end
