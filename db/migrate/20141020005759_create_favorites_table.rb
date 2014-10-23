class CreateFavoritesTable < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
    end
    add_reference :favorites, :user
    add_reference :favorites, :channel
  end
end
