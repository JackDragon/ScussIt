class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :body
      t.datetime :creation_time

      t.timestamps
    end
    add_belongs_to :messages, :user
    add_belongs_to :messages, :channel
  end
end
