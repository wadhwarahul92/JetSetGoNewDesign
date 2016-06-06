class AddBiasToAirports < ActiveRecord::Migration
  def change
    add_column :airports, :bais_time_in_minutes, :integer, default: 0
  end
end
