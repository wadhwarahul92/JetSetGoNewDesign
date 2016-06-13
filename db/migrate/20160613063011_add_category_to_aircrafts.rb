class AddCategoryToAircrafts < ActiveRecord::Migration
  def change
    add_column :aircrafts, :category, :string
  end
end
