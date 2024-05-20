class Recipe < ApplicationRecord
  has_many :recipe_ingredients
  has_many :ingredients, through: :recipe_ingredients

  validates :title, presence: true, uniqueness: true

  # Scope to filter recipes by ingredients
  scope :with_ingredients, ->(ingredient_names) {
    joins(:ingredients)
      .where(ingredients: { name: ingredient_names })
      .group('recipes.id')
      .having('COUNT(ingredients.id) = ?', ingredient_names.size)
  }
end
