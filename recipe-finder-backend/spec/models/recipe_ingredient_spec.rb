require 'rails_helper'

RSpec.describe RecipeIngredient do
  let(:recipe_ingredient) { build(:recipe_ingredient) }
  let(:recipe_ingredient_without_recipe) { build(:recipe_ingredient, recipe: nil) }
  let(:recipe_ingredient_without_ingredient) { build(:recipe_ingredient, ingredient: nil) }

  it 'is valid with valid attributes' do
    expect(recipe_ingredient).to be_valid
  end

  it 'is invalid without a recipe' do
    expect(recipe_ingredient_without_recipe).not_to be_valid
  end

  it 'is invalid without an ingredient' do
    expect(recipe_ingredient_without_ingredient).not_to be_valid
  end
end
