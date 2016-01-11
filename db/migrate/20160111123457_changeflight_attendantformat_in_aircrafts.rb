class ChangeflightAttendantformatInAircrafts < ActiveRecord::Migration
  def change
    change_column :aircrafts, :flight_attendant, :boolean, default: false
  end
end
