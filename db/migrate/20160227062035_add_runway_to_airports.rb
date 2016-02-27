class AddRunwayToAirports < ActiveRecord::Migration
  def change
    add_column :airports, :runway_field_length_in_feet, :float
  end
end
