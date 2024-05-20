class Recipe < ApplicationRecord
  has_many :recipe_ingredients
  has_many :ingredients, through: :recipe_ingredients

  validates :title, presence: true, uniqueness: true

  # Scope to filter recipes by ingredients using partial match
  scope :with_ingredients, ->(ingredient_names) {
    joins(:ingredients)
      .where(ingredient_names.map { |name| "ingredients.name ILIKE ?" }.join(' OR '), *ingredient_names.map { |name| "%#{name}%" })
      .group('recipes.id')
      .having('COUNT(ingredients.id) >= ?', ingredient_names.size)
  }
end
