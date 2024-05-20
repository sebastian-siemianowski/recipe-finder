require 'rails_helper'

RSpec.describe "Recipes", type: :request do
  describe "GET /recipes" do
    let!(:recipe1) { create(:recipe, title: 'Recipe 1') }
    let!(:recipe2) { create(:recipe, title: 'Recipe 2') }
    let!(:ingredient1) { create(:ingredient, name: 'flour') }
    let!(:ingredient2) { create(:ingredient, name: 'sugar') }

    before do
      recipe1.ingredients << [ingredient1, ingredient2]
      recipe2.ingredients << [ingredient1]
    end

    it "returns recipes with the specified ingredients" do
      get recipes_path, params: { ingredients: 'flour,sugar' }
      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response.size).to eq(1)
      expect(json_response.first['title']).to eq('Recipe 1')
    end

    it "returns an error if no ingredients are provided" do
      get recipes_path, params: { ingredients: '' }
      expect(response).to have_http_status(:unprocessable_entity)
      json_response = JSON.parse(response.body)
      expect(json_response['error']).to eq('No ingredients provided')
    end
  end
end
