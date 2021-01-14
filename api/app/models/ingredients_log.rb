class IngredientsLog < ApplicationRecord
  belongs_to :ingredient
  belongs_to :user

  # This model will use the safety_rating enum from the Ingredient model to keep things DRY
  enum safety_rating: Ingredient.safety_ratings
end
