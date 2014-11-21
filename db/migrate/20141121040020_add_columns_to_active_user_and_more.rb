class AddColumnsToActiveUserAndMore < ActiveRecord::Migration
  def change
    add_column :actives, :topic_name, :string
  end
end
