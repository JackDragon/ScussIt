class FixTopicsTable < ActiveRecord::Migration
  def change
    drop_table :topic
    create_table :topics do |t|
        t.string :name
    end
    add_reference :topics, :channel
    add_reference :messages, :topics
  end
end
