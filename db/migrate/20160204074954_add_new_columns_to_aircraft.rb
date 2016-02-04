class AddNewColumnsToAircraft < ActiveRecord::Migration
  def change
    add_column :aircrafts, :year_of_manufacture, :string
    add_column :aircrafts, :medical_evac, :boolean, default: false
    add_column :aircrafts, :cruise_speed_in_nm_per_hour, :float
    add_column :aircrafts, :flying_range_in_nm, :float
    add_column :aircrafts, :per_hour_cost, :float
    add_column :aircrafts, :catering_cost_per_pax, :float
    add_column :aircrafts, :admin_verified, :boolean, default: false
    add_column :aircrafts, :operator_id, :integer
  end
end
