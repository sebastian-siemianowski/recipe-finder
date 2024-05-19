require 'rails_helper'

RSpec.describe RecipeIngredient, type: :model do
  it 'is valid with valid attributes' do
    recipe_ingredient = build(:recipe_ingredient)
    expect(recipe_ingredient).to be_valid
  end

  it 'is invalid without a recipe' do
    recipe_ingredient = build(:recipe_ingredient, recipe: nil)
    expect(recipe_ingredient).not_to be_valid
  end

  it 'is invalid without an ingredient' do
    recipe_ingredient = build(:recipe_ingredient, ingredient: nil)
    expect(recipe_ingredient).not_to be_valid
  end
end
