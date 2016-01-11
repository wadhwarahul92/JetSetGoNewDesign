class AddValuesToAircrafts < ActiveRecord::Migration
  def change
    add_column :aircrafts, :crew, :integer
    add_column :aircrafts, :wifi, :boolean, deafult: false
    add_column :aircrafts, :phone, :boolean, deafult: false
    add_column :aircrafts, :flight_attendant, :integer
  end
end
