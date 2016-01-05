class AddValuesToAircrafts < ActiveRecord::Migration
  def change
    add_column :aircrafts, :crew, :integer
    add_column :aircrafts, :wifi, :boolean
    add_column :aircrafts, :phone, :boolean
    add_column :aircrafts, :flight_attendant, :integer
  end
end
