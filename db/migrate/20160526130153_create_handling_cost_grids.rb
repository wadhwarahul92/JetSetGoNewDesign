class CreateHandlingCostGrids < ActiveRecord::Migration
  def change
    create_table :handling_cost_grids do |t|
      t.integer :aircraft_id
      t.integer :airport_id
      t.float :cost, default: 0.0

      t.timestamps null: false
    end
  end
end
