class RemakeAddActiveUsersTable < ActiveRecord::Migration
  def change
    drop_table :active
    create_table :actives do |t|
    end
    # remove_reference :active, :user
    # remove_reference :active, :channel
    add_reference :actives, :user
    add_reference :actives, :channel
  end
end
