class DropTableCcAvenueTransaction < ActiveRecord::Migration
  def change
    drop_table :cc_avenue_transactions
    rename_column :jetsteal_seats, :cc_avenue_transaction_id, :transaction_id
  end
end
