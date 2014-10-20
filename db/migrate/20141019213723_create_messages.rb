class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :body
      t.datetime :creation_time

      t.timestamps
    end
  end
end
