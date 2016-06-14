class AddOtherCostToAirportSuppliers < ActiveRecord::Migration
  def change
    add_column :airport_suppliers, :other_service_cost, :float
    add_column :airport_suppliers, :max_other_service, :boolean, default: false
  end
end
