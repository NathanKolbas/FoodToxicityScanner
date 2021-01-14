class User < ApplicationRecord
  has_secure_password

  has_many :ingredients_logs
  has_many :ingredients, through: :ingredients_logs
  has_many :ingredients, foreign_key: :created_by

  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }, on: :create
  validates :password, allow_blank: true, length: { minimum: 6 }, on: :update

  # Remove password_digest as to not expose the hash
  def as_json(options = {})
    super(options.merge({ except: :password_digest }))
  end
end
