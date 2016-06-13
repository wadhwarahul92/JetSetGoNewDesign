class AddAircraftCategoryIdToAircraftTypes < ActiveRecord::Migration
  def change
    add_column :aircraft_types, :aircraft_category_id, :integer
  end
end
