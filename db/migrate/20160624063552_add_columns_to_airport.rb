class AddColumnsToAirport < ActiveRecord::Migration
  def change
    add_column :airports, :landing_minimum_mtow, :float, default: 0.0
    add_column :airports, :landing_maximum_mtow, :float, default: 0.0
    add_column :airports, :landing_minimum_amount, :float, default: 0.0
  end
end
