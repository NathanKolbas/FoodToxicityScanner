class CreateIngredients < ActiveRecord::Migration[6.0]
  def change
    create_table :ingredients do |t|
      t.string :name, null: false
      t.string :description, null: false
      t.integer :safety_rating, default: 0
      t.integer :created_by

      t.timestamps null: true
    end
  end
end
