class AddCommissionParametersToAircraft < ActiveRecord::Migration
  def change
    add_column :aircrafts, :flight_cost_commission_in_percentage, :integer, default: 10
    add_column :aircrafts, :handling_cost_commission_in_percentage, :integer, default: 10
    add_column :aircrafts, :accomodation_cost_commission_in_percentage, :integer, default: 10
  end
end
