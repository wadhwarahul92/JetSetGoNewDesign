class AddLongitudeLatitudeToAirports < ActiveRecord::Migration
  def change
    add_column :airports, :longitude, :float
    add_column :airports, :latitude, :float
  end
end
