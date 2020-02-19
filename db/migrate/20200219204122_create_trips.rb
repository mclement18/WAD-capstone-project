class CreateTrips < ActiveRecord::Migration[5.1]
  def change
    create_table :trips do |t|
      t.string :title
      t.text :description
      t.string :image
      t.string :categories
      t.string :location

      t.timestamps
    end
  end
end
