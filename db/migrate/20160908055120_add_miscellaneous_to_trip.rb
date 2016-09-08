class AddMiscellaneousToTrip < ActiveRecord::Migration
  def change
    add_column :trips, :is_miscellaneous_expenses, :boolean, default: false
    add_column :trips, :miscellaneous_expenses, :float, default: 0.0
  end
end
