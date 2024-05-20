class RecipesController < ApplicationController
  # Index action to filter recipes by ingredients
  def index
    ingredients = params[:ingredients]
    if ingredients.present?
      ingredient_list = ingredients.split(',').map(&:strip)
      recipes = Recipe.with_ingredients(ingredient_list)
      render json: recipes
    else
      render json: { error: 'No ingredients provided' }, status: :unprocessable_entity
    end
  end
end
