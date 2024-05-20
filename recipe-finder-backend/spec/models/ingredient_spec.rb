require 'rails_helper'

RSpec.describe Ingredient do
  let(:ingredient) { build(:ingredient) }
  let(:ingredient_without_name) { build(:ingredient, name: nil) }
  let(:ingredient_with_recipes) { create(:ingredient) }
  let(:recipe1) { create(:recipe) }
  let(:recipe2) { create(:recipe, title: 'Another Recipe') }

  it 'is valid with valid attributes' do
    expect(ingredient).to be_valid
  end

  it 'is invalid without a name' do
    expect(ingredient_without_name).not_to be_valid
  end

  it 'has many recipes through recipe_ingredients' do
    ingredient_with_recipes.recipes << [recipe1, recipe2]
    expect(ingredient_with_recipes.recipes).to include(recipe1, recipe2)
  end
end
