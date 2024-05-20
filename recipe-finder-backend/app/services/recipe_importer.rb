class RecipeImporter
  def self.import(file_path)
    json = File.read(file_path)
    recipes = JSON.parse(json)

    # Limit the number of records in test environment
    recipes = recipes.first(20) if Rails.env.test?

    bar = ProgressBar.new(recipes.size)

    recipes.each do |recipe_data|
      recipe = Recipe.find_or_create_by(title: recipe_data["title"]) do |r|
        r.cook_time = recipe_data["cook_time"]
        r.prep_time = recipe_data["prep_time"]
        r.ratings = recipe_data["ratings"]
        r.cuisine = recipe_data["cuisine"]
        r.category = recipe_data["category"]
        r.author = recipe_data["author"]
        r.image = recipe_data["image"]
      end

      recipe_data["ingredients"].each do |ingredient_name|
        ingredient = Ingredient.find_or_create_by(name: ingredient_name)
        RecipeIngredient.find_or_create_by(recipe: recipe, ingredient: ingredient)
      end

      bar.increment!
    end

    puts "\nRecipes imported successfully!"
  end
end
