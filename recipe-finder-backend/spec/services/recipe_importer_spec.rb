require 'rails_helper'

RSpec.describe RecipeImporter do
  describe '.import' do
    let(:file_path) { Rails.root.join('spec', 'fixtures', 'files', 'recipes-en.json') }

    before do
      # Create a sample JSON file in the fixtures directory
      File.open(file_path, 'w') do |f|
        f.write([
                  {
                    "title": "Golden Sweet Cornbread",
                    "cook_time": 25,
                    "prep_time": 10,
                    "ingredients": [
                      "1 cup all-purpose flour",
                      "1 cup yellow cornmeal",
                      "⅔ cup white sugar",
                      "1 teaspoon salt",
                      "3 ½ teaspoons baking powder",
                      "1 egg",
                      "1 cup milk",
                      "⅓ cup vegetable oil"
                    ],
                    "ratings": 4.74,
                    "cuisine": "",
                    "category": "Cornbread",
                    "author": "bluegirl",
                    "image": "https://example.com/image.jpg"
                  },
                  {
                    "title": "Golden Sweet Cornbread",
                    "cook_time": 30,
                    "prep_time": 15,
                    "ingredients": [
                      "2 cups all-purpose flour",
                      "2 cups yellow cornmeal",
                      "1⅓ cup white sugar",
                      "2 teaspoons salt",
                      "7 teaspoons baking powder",
                      "2 eggs",
                      "2 cups milk",
                      "⅔ cup vegetable oil"
                    ],
                    "ratings": 4.75,
                    "cuisine": "",
                    "category": "Cornbread",
                    "author": "bluegirl",
                    "image": "https://example.com/image.jpg"
                  },
                  {
                    "title": "Monkey Bread I",
                    "cook_time": 35,
                    "prep_time": 15,
                    "ingredients": [
                      "3 (12 ounce) packages refrigerated biscuit dough",
                      "1 cup white sugar",
                      "2 teaspoons ground cinnamon",
                      "½ cup margarine",
                      "1 cup packed brown sugar",
                      "½ cup chopped walnuts",
                      "½ cup raisins"
                    ],
                    "ratings": 4.74,
                    "cuisine": "",
                    "category": "Monkey Bread",
                    "author": "deleteduser",
                    "image": "https://example.com/image.jpg"
                  }
                ].to_json)
      end
    end

    after do
      # Clean up the sample JSON file
      File.delete(file_path) if File.exist?(file_path)
    end

    it 'imports recipes from JSON file' do
      expect { RecipeImporter.import(file_path) }.to change { Recipe.count }.by(2)
      expect(Recipe.find_by(title: 'Golden Sweet Cornbread').cook_time).to eq(25)
      expect(Recipe.find_by(title: 'Monkey Bread I')).not_to be_nil
    end

    it 'does not create duplicate recipes' do
      create(:recipe, title: 'Golden Sweet Cornbread')
      expect { RecipeImporter.import(file_path) }.to change { Recipe.count }.by(1)
    end
  end
end
