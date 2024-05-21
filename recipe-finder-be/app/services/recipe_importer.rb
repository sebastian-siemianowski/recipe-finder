class RecipeImporter
  def self.import(file_path)
    if Recipe.exists?
      Rails.logger.debug "Recipes already exist. Skipping import."
      return
    end

    recipes = load_recipes(file_path)
    limit_records_for_test_environment!(recipes)
    import_recipes_with_progress(recipes)
    Rails.logger.debug "\nRecipes imported successfully!"
  end

  private

  # Load recipes from the JSON file
  def self.load_recipes(file_path)
    json = File.read(file_path)
    JSON.parse(json)
  rescue Errno::ENOENT => e
    log_error("File not found: #{file_path}")
    []
  rescue JSON::ParserError => e
    log_error("Failed to parse JSON file: #{e.message}")
    []
  end

  # Limit the number of records in the test environment
  def self.limit_records_for_test_environment!(recipes)
    recipes.slice!(20, recipes.size - 20) if Rails.env.test?
  end

  # Import recipes with a progress bar
  def self.import_recipes_with_progress(recipes)
    bar = ProgressBar.new(recipes.size)
    recipes.each do |recipe_data|
      import_recipe(recipe_data)
      bar.increment!
    end
  end

  # Import a single recipe and its ingredients
  def self.import_recipe(recipe_data)
    ActiveRecord::Base.transaction do
      recipe = find_or_create_recipe(recipe_data)
      find_or_create_ingredients(recipe, recipe_data["ingredients"])
    end
  rescue ActiveRecord::RecordInvalid => e
    log_error("Failed to import recipe: #{e.message}")
  end

  # Find or create a recipe
  def self.find_or_create_recipe(recipe_data)
    Recipe.find_or_create_by!(title: recipe_data["title"]) do |recipe|
      recipe.assign_attributes(
        cook_time: recipe_data["cook_time"],
        prep_time: recipe_data["prep_time"],
        ratings: recipe_data["ratings"],
        cuisine: recipe_data["cuisine"],
        category: recipe_data["category"],
        author: recipe_data["author"],
        image: recipe_data["image"]
      )
    end
  end

  # Find or create ingredients for a recipe
  def self.find_or_create_ingredients(recipe, ingredient_names)
    ingredient_names.each do |ingredient_name|
      ingredient = Ingredient.find_or_create_by!(name: ingredient_name)
      RecipeIngredient.find_or_create_by!(recipe: recipe, ingredient: ingredient)
    end
  end

  # Log error messages
  def self.log_error(message)
    Rails.logger.error(message)
    Rails.logger.debug message
  end
end
