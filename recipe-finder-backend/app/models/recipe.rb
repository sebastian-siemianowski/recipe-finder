class Recipe < ApplicationRecord
  has_many :recipe_ingredients, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredients

  validates :title, presence: true, uniqueness: true

  # Scope to filter recipes by ingredients using partial match
  scope :with_ingredients, ->(ingredient_names) {
    return none if ingredient_names.blank?

    sanitized_names = sanitize_ingredient_names(ingredient_names)
    conditions = build_conditions(sanitized_names)
    named_bindings = build_named_bindings(sanitized_names)

    joins(:ingredients)
      .where(conditions, named_bindings)
      .group('recipes.id')
      .having('COUNT(DISTINCT ingredients.id) >= ?', ingredient_names.size)
  }

  private

  # Sanitize input to prevent SQL injection
  def self.sanitize_sql_like(string)
    pattern = Regexp.union('%', '_', '\\')
    string.gsub(pattern) { |x| "\\#{x}" }
  end

  # Sanitize a list of ingredient names
  def self.sanitize_ingredient_names(names)
    names.map { |name| sanitize_sql_like(name) }
  end

  # Build SQL conditions for ingredient names
  def self.build_conditions(sanitized_names)
    sanitized_names.map.with_index { |name, index| "ingredients.name ILIKE :name_#{index}" }.join(' OR ')
  end

  # Build named bindings for ingredient names
  def self.build_named_bindings(sanitized_names)
    sanitized_names.each_with_object({}).with_index do |(name, hash), index|
      hash[:"name_#{index}"] = "%#{name}%"
    end
  end
end
