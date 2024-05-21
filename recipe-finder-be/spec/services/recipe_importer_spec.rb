require 'rails_helper'

RSpec.describe RecipeImporter, type: :model do
  let(:file_path) { Rails.root.join("lib/assets/recipes-en.json") }
  let(:json_data) { File.read(file_path) }
  let(:recipes) { JSON.parse(json_data) }

  describe '.import' do
    context 'when importing recipes' do
      it 'imports recipes successfully' do
        expect { described_class.import(file_path) }.to change(Recipe, :count).by_at_least(1)
      end

      it 'limits records in the test environment' do
        allow(Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new('test'))
        described_class.import(file_path)
        expect(Recipe.count).to be <= 20
      end

      it 'creates ingredients for recipes' do
        described_class.import(file_path)
        expect(Ingredient.count).to be > 0
      end

      it 'creates recipe ingredients associations' do
        described_class.import(file_path)
        expect(RecipeIngredient.count).to be > 0
      end
    end
  end
end
