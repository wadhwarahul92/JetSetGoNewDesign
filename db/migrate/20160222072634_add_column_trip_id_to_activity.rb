class AddColumnTripIdToActivity < ActiveRecord::Migration
  def change
    add_column :activities, :trip_id, :integer
  end
end
