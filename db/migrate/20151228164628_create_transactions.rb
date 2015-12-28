class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :contact_id
      t.string :status, default: 'pending'

      t.timestamps null: false
    end
  end
end
