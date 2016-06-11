class CreateSuppliers < ActiveRecord::Migration
  def change
    create_table :suppliers do |t|
      t.text :name
      t.boolean :fuel_supplier, default: false
      t.boolean :ground_handling, default: false
      t.boolean :other_services, default: false

      t.timestamps null: false
    end
  end
end
