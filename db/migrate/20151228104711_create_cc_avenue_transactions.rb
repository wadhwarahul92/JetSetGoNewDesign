class CreateCcAvenueTransactions < ActiveRecord::Migration
  def change
    create_table :cc_avenue_transactions do |t|
      t.integer :contact_id
      t.boolean :success, default: false

      t.timestamps null: false
    end
  end
end
