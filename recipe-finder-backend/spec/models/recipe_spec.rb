require 'rails_helper'

RSpec.describe Recipe, type: :model do
  it 'is valid with valid attributes' do
    recipe = build(:recipe)
    expect(recipe).to be_valid
  end

  it 'can have ingredients' do
    recipe = create(:recipe)
    ingredient = create(:ingredient)
    recipe.ingredients << ingredient

    expect(recipe.ingredients).to include(ingredient)
  end

  it 'can have multiple ingredients' do
    recipe = create(:recipe)
    ingredient1 = create(:ingredient, name: "all-purpose flour")
    ingredient2 = create(:ingredient, name: "yellow cornmeal")

    recipe.ingredients << ingredient1
    recipe.ingredients << ingredient2

    expect(recipe.ingredients).to include(ingredient1, ingredient2)
  end
end
