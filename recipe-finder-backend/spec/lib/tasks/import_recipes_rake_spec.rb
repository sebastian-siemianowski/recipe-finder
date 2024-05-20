require 'rails_helper'
require 'rake'

RSpec.describe 'import:recipes', type: :task do
  let(:task) { Rake::Task['import:recipes'] }
  let(:file_path) { Rails.root.join('lib', 'assets', 'recipes-en.json') }

  before(:all) do
    # Ensure rake tasks are loaded
    Rake.application.rake_require 'tasks/import_recipes'
    Rake::Task.define_task(:environment)
  end

  before(:each) do
    Recipe.delete_all
    Ingredient.delete_all
    RecipeIngredient.delete_all
  end

  it 'imports a maximum of 20 recipes in the test environment' do
    expect { task.invoke }.to change { Recipe.count }.by_at_most(20)
  end
end
