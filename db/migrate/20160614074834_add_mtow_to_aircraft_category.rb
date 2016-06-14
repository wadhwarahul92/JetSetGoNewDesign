class AddMtowToAircraftCategory < ActiveRecord::Migration
  def change
    add_column :aircraft_categories, :mtow, :float
  end
end
