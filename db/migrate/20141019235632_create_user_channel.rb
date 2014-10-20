class CreateUserChannel < ActiveRecord::Migration
  def change
    create_table :user_channels do |t|
      t.datetime :timeout
    end

    add_reference :user_channels, :user
    add_reference :user_channels, :channel
  end
end
