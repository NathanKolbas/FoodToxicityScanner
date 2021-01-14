class Ingredient < ApplicationRecord
  has_many :ingredients_logs
  has_many :users, through: :ingredients_logs
  belongs_to :user, foreign_key: :created_by

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :description, presence: true

  enum safety_rating: {
    unavailable: 0,
    safe: 1,
    caution: 2,
    cut: 3,
    cpsa: 4,
    avoid: 5
  }
end
