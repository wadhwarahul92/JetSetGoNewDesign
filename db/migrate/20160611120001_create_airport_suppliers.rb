class CreateAirportSuppliers < ActiveRecord::Migration
  def change
    create_table :airport_suppliers do |t|
      t.string :halt_type
      t.integer :minimum_mtow, default: 0
      t.integer :maximum_mtow, default: 0
      t.float :minimum_amount, default: 0.0
      t.float :offset_amount, default: 0.0
      t.float :rate_per_tonne, default: 0.0
      t.float :royalty, default: 0.0
      t.float :additional_rate, default: 0.0

      t.timestamps null: false
    end
  end
end
