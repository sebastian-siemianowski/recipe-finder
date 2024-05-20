class RecipesController < ApplicationController
  # Index action to filter recipes by ingredients with pagination
  def index
    ingredients = params[:ingredients]
    page = params[:page] || 1
    if ingredients.present?
      ingredient_list = ingredients.split(',').map(&:strip)
      recipes = Recipe.with_ingredients(ingredient_list).page(page).per(10)
      render json: {
        recipes: recipes,
        total_pages: recipes.total_pages,
        current_page: recipes.current_page
      }
    else
      render json: { error: 'No ingredients provided' }, status: :unprocessable_entity
    end
  end
end
