class AddFlightdurationToJetsteals < ActiveRecord::Migration
  def change
    add_column :jetsteals, :flight_duration_in_minutes, :integer
  end
end
