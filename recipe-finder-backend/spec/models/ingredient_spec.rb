require 'rails_helper'

RSpec.describe Ingredient, type: :model do
  it 'is valid with valid attributes' do
    ingredient = build(:ingredient)
    expect(ingredient).to be_valid
  end

  it 'is invalid without a name' do
    ingredient = build(:ingredient, name: nil)
    expect(ingredient).not_to be_valid
  end

  it 'has many recipes through recipe_ingredients' do
    ingredient = create(:ingredient)
    recipe1 = create(:recipe)
    recipe2 = create(:recipe)

    ingredient.recipes << recipe1
    ingredient.recipes << recipe2

    expect(ingredient.recipes).to include(recipe1, recipe2)
  end
end
