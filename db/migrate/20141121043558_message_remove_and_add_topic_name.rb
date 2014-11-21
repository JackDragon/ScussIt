class MessageRemoveAndAddTopicName < ActiveRecord::Migration
  def change
    remove_reference :messages, :topic
    add_column :messages, :topic_name, :string
  end
end
