require 'rails_helper'

RSpec.describe "Recipes", type: :request do
  describe "GET /recipes" do
    let!(:recipe1) { create(:recipe, title: 'Recipe 1') }
    let!(:recipe2) { create(:recipe, title: 'Recipe 2') }
    let!(:ingredient1) { create(:ingredient, name: 'all-purpose flour') }
    let!(:ingredient2) { create(:ingredient, name: 'white sugar') }

    before do
      recipe1.ingredients << [ingredient1, ingredient2]
      recipe2.ingredients << [ingredient1]
    end

    it "returns recipes with partial matching ingredients and handles pagination" do
      get recipes_path, params: { ingredients: 'flour,sugar', page: 1 }
      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response["recipes"].size).to eq(1)
      expect(json_response["recipes"].first['title']).to eq('Recipe 1')
      expect(json_response["total_pages"]).to eq(1)
      expect(json_response["current_page"]).to eq(1)
    end

    it "returns an error if no ingredients are provided" do
      get recipes_path, params: { ingredients: '' }
      expect(response).to have_http_status(:unprocessable_entity)
      json_response = JSON.parse(response.body)
      expect(json_response['error']).to eq('No ingredients provided')
    end
  end
end
