# This migration adds a unique index to the title column of the recipes table
# to enforce the uniqueness constraint at the database level.
class AddUniqueIndexToRecipesTitle < ActiveRecord::Migration[7.0]
  def change
    add_index :recipes, :title, unique: true
  end
end
