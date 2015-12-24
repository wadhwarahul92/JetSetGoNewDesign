class AddColumnsSeatingToAircraft < ActiveRecord::Migration
  def change
    add_column :aircrafts, :seating_capacity, :integer
    add_column :aircrafts, :baggage_capacity_in_kg, :integer
    add_column :aircrafts, :landing_field_length_in_feet, :integer
    add_column :aircrafts, :runway_field_length_in_feet, :integer
    add_column :aircrafts, :number_of_toilets, :integer
    add_column :aircrafts, :cabin_width_in_meters, :float
    add_column :aircrafts, :cabin_height_in_meters, :float
    add_column :aircrafts, :cabin_length_in_meters, :float
  end
end
