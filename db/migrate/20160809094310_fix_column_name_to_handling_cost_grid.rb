class FixColumnNameToHandlingCostGrid < ActiveRecord::Migration
  def change
    rename_column :handling_cost_grids, :airport_id, :city_id
    rename_column :handling_cost_grids, :aircraft_id, :aircraft_category_id
  end
end
