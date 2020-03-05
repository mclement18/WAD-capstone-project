class CreateToDos < ActiveRecord::Migration[5.1]
  def change
    create_table :to_dos do |t|
      t.references :user, foreign_key: true
      t.references :trip, foreign_key: true
      t.string :status

      t.timestamps
    end
  end
end
