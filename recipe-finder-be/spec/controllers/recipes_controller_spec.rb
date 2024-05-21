require 'rails_helper'

RSpec.describe RecipesController do
  describe 'GET #index' do
    let(:ingredient) { create(:ingredient) }
    let(:valid_ingredients) { 'flour' }
    let(:invalid_ingredients) { '' }
    let!(:recipes) { create_list(:recipe, 15) }

    before do
      recipes.each { |recipe| recipe.ingredients << ingredient }
    end

    context 'with valid ingredients' do
      let(:params) { { ingredients: valid_ingredients, page: 1 } }

      it 'returns recipes and handles pagination' do
        get :index, params: params
        json_response = response.parsed_body

        expect(response).to have_http_status(:ok)
        expect(json_response['recipes'].length).to be <= 10
        expect(json_response['total_pages']).to be > 1
        expect(json_response['current_page']).to eq(1)
        expect(json_response['total_count']).to eq(15)
      end
    end

    context 'with no ingredients provided' do
      let(:params) { { ingredients: invalid_ingredients } }

      it 'returns an error' do
        get :index, params: params
        json_response = response.parsed_body

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['error']).to eq('No ingredients provided')
      end
    end

    context 'with invalid page parameter' do
      let(:params) { { ingredients: valid_ingredients, page: 'invalid' } }

      it 'defaults to page 1' do
        get :index, params: params
        json_response = response.parsed_body

        expect(response).to have_http_status(:ok)
        expect(json_response['current_page']).to eq(1)
      end
    end

    context 'when an unexpected error occurs' do
      let(:params) { { ingredients: valid_ingredients, page: 1 } }

      before do
        allow(Recipe).to receive(:with_ingredients).and_raise(StandardError, 'unexpected error')
      end

      it 'returns an internal server error' do
        get :index, params: params
        json_response = response.parsed_body

        expect(response).to have_http_status(:internal_server_error)
        expect(json_response['error']).to eq('An error occurred while processing your request.')
      end
    end
  end
end
