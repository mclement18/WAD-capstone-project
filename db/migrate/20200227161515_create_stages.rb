class CreateStages < ActiveRecord::Migration[5.1]
  def change
    create_table :stages do |t|
      t.string :title
      t.text :description
      t.string :image
      t.integer :number
      t.string :travel_type
      t.text :directions
      t.string :address
      t.references :trip, foreign_key: true

      t.timestamps
    end
  end
end
