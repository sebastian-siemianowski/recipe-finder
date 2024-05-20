require 'rails_helper'

RSpec.describe Recipe do
  let(:recipe) { build(:recipe) }
  let(:ingredient) { create(:ingredient) }
  let(:ingredient1) { create(:ingredient, name: "all-purpose flour") }
  let(:ingredient2) { create(:ingredient, name: "yellow cornmeal") }

  it 'is valid with valid attributes' do
    expect(recipe).to be_valid
  end

  it 'can have ingredients' do
    recipe.save
    recipe.ingredients << ingredient
    expect(recipe.ingredients).to include(ingredient)
  end

  it 'can have multiple ingredients' do
    recipe.save
    recipe.ingredients << [ingredient1, ingredient2]
    expect(recipe.ingredients).to include(ingredient1, ingredient2)
  end
end
