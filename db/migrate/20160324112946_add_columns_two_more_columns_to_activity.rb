class AddColumnsTwoMoreColumnsToActivity < ActiveRecord::Migration
  def change
    add_column :activities, :watch_hour_at_arrival, :boolean, default: false
    add_column :activities, :watch_hour_cost, :float, default: 0
  end
end
