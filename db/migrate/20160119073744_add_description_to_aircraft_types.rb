class AddDescriptionToAircraftTypes < ActiveRecord::Migration
  def change
    add_column :aircraft_types, :description, :text
  end
end
