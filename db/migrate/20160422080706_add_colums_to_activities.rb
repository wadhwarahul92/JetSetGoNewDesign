class AddColumsToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :empty_leg_whole_price, :float, default: 0.0
    add_column :activities, :empty_leg_seat_price, :float, default: 0.0
  end
end
