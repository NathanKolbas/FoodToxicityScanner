class CreateIngredientsLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :ingredients_logs do |t|
      t.integer :ingredient_id
      t.integer :user_id
      t.string :name
      t.string :description
      t.integer :safety_rating

      t.timestamps
    end
  end
end
