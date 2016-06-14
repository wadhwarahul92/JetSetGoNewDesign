class AddColumnMtowToAircraftType < ActiveRecord::Migration
  def change
    add_column :aircraft_types, :mtow, :float
  end
end
