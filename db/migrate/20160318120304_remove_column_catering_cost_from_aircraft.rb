class RemoveColumnCateringCostFromAircraft < ActiveRecord::Migration
  def change
    remove_column :aircrafts, :catering_cost_per_pax
  end
end
