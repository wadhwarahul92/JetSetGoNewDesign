class AddColumnLandingCostToAirport < ActiveRecord::Migration
  def change
    add_column :airports, :landing_cost, :float, default: 0
  end
end
