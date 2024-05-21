namespace :import do
  desc "Import recipes from JSON file"
  task recipes: :environment do
    file_path = Rails.root.join('lib', 'assets', 'recipes-en.json')
    RecipeImporter.import(file_path)
  end
end
