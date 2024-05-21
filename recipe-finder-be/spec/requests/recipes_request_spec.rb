require 'rails_helper'

RSpec.describe "Recipes" do
  let!(:recipe1) { create(:recipe, title: 'Recipe 1') }
  let!(:recipe2) { create(:recipe, title: 'Recipe 2') }
  let!(:ingredient1) { create(:ingredient, name: 'all-purpose flour') }
  let!(:ingredient2) { create(:ingredient, name: 'white sugar') }

  before do
    recipe1.ingredients << [ingredient1, ingredient2]
    recipe2.ingredients << [ingredient1]
  end

  describe "GET /recipes" do
    context "with partial matching ingredients and pagination" do
      let(:params) { { ingredients: 'flour,sugar', page: 1 } }

      it "returns recipes and handles pagination" do
        get recipes_path, params: params
        expect(response).to have_http_status(:success)
        json_response = response.parsed_body
        expect(json_response["recipes"].size).to eq(1)
        expect(json_response["recipes"].first['title']).to eq('Recipe 1')
        expect(json_response["total_pages"]).to eq(1)
        expect(json_response["current_page"]).to eq(1)
      end
    end

    context "without ingredients" do
      let(:params) { { ingredients: '' } }

      it "returns an error" do
        get recipes_path, params: params
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = response.parsed_body
        expect(json_response['error']).to eq('No ingredients provided')
      end
    end
  end
end
