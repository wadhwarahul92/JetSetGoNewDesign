class AddSpeedToAircraftType < ActiveRecord::Migration
  def change
    add_column :aircraft_types, :speed_in_kts, :float
  end
end
