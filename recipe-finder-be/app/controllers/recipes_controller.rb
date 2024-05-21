class RecipesController < ApplicationController
  # Index action to filter recipes by ingredients with pagination
  def index
    if ingredients_present?
      recipes = fetch_filtered_recipes
      render json: recipes_response(recipes)
    else
      render json: { error: 'No ingredients provided' }, status: :unprocessable_entity
    end
  rescue StandardError => e
    log_error(e)
    render json: { error: 'An error occurred while processing your request.' }, status: :internal_server_error
  end

  private

  # Check if ingredients parameter is present
  def ingredients_present?
    params[:ingredients].present?
  end

  # Fetch filtered recipes based on ingredients and pagination
  def fetch_filtered_recipes
    ingredient_list = sanitize_ingredients(params[:ingredients])

    Recipe.with_ingredients(ingredient_list).page(current_page).per(per_page)
  end

  # Sanitize and split ingredients parameter
  def sanitize_ingredients(ingredients)
    ingredients.split(',').map(&:strip).reject(&:empty?)
  end

  # Get the current page parameter
  def current_page
    params.fetch(:page, 1).to_i
  end

  # Get the per page parameter (number of records per page)
  def per_page
    params.fetch(:per_page, 10).to_i
  end

  # Format the response for recipes with pagination
  def recipes_response(recipes)
    {
      recipes: recipes.as_json(only: [:id, :title, :cook_time, :prep_time, :ratings, :cuisine, :category, :author,
                                      :image]),
      total_pages: recipes.total_pages,
      current_page: recipes.current_page,
      total_count: recipes.total_count
    }
  end

  # Log error messages
  def log_error(exception)
    Rails.logger.error("Error: #{exception.message}")
    Rails.logger.error(exception.backtrace.join("\n"))
  end
end
