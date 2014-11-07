class AddTimeToActiveUsersTable < ActiveRecord::Migration
  def change
    add_column :actives, :updated, :datetime
  end
end
