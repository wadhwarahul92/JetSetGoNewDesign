class AddFieldsToAirports < ActiveRecord::Migration
  def change
    add_column :airports, :private_landing, :boolean
    add_column :airports, :international, :boolean
    add_column :airports, :night_landing, :boolean
    add_column :airports, :night_parking, :boolean
    add_column :airports, :ifr_or_vfr, :string
    add_column :airports, :fuel_availability, :boolean
    add_column :airports, :watch_hour_extension, :boolean
  end
end
