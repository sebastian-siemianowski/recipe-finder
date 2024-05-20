require_relative '../app/services/recipe_importer'

file_path = Rails.root.join("lib/assets/recipes-en.json")
RecipeImporter.import(file_path)
