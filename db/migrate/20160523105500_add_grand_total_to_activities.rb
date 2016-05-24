class AddGrandTotalToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :grand_total, :float, default: 0.0
  end
end
