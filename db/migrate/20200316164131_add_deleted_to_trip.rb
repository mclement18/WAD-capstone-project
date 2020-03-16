class AddDeletedToTrip < ActiveRecord::Migration[5.1]
  def change
    add_column :trips, :deleted, :boolean
  end
end
