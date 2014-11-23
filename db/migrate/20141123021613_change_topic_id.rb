class ChangeTopicId < ActiveRecord::Migration
  def change
  	remove_column :messages, :topics_id
  	add_column :messages, :topic_id, :integer
  end
end
