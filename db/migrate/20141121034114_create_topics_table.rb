class CreateTopicsTable < ActiveRecord::Migration
  def change
    create_table :topic do |t|
        t.string :name
    end
    add_reference :topic, :channel
    add_reference :messages, :topic
  end
end
