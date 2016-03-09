class CreateTaxes < ActiveRecord::Migration
  def change
    create_table :taxes do |t|
      t.float :service_tax
      t.float :swachh_bharat_cess

      t.timestamps null: false
    end
  end
end
