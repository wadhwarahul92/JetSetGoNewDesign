class AddColumnDeletedAtInSeveral < ActiveRecord::Migration
  def change
    add_column :activities, :deleted_at, :datetime
    add_column :aircrafts, :deleted_at, :datetime
    add_column :aircraft_unavailabilities, :deleted_at, :datetime
    add_column :trips, :deleted_at, :datetime
  end
end
