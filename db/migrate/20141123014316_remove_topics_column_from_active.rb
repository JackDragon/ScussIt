class RemoveTopicsColumnFromActive < ActiveRecord::Migration
  def change
    remove_column :actives, :topic_name
  end
end
