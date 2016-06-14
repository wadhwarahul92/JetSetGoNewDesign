class AddMtowToAircraft < ActiveRecord::Migration
  def change
    add_column :aircrafts, :mtow, :float
  end
end
