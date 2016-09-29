class AddJsgFleetToAircraft < ActiveRecord::Migration
  def change
    add_column :aircrafts, :is_jsg_fleet, :boolean, default: false
  end
end
