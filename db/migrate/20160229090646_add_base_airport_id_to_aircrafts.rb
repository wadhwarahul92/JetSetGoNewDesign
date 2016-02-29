class AddBaseAirportIdToAircrafts < ActiveRecord::Migration
  def change
    add_column :aircrafts, :base_airport_id, :integer
  end
end
