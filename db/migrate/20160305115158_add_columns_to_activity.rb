class AddColumnsToActivity < ActiveRecord::Migration
  def change
    add_column :activities, :flight_cost, :float, default: 0
    add_column :activities, :handling_cost_at_takeoff, :float, default: 0
    add_column :activities, :landing_cost_at_arrival, :float, default: 0
  end
end
