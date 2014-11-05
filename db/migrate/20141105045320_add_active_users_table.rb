class AddActiveUsersTable < ActiveRecord::Migration
  def change
    create_table :active do |t|
    end
    add_reference :active, :user
    add_reference :active, :channel
  end
end
