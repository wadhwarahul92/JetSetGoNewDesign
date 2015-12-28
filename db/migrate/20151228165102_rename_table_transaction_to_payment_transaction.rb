class RenameTableTransactionToPaymentTransaction < ActiveRecord::Migration
  def change
    rename_table :transactions, :payment_transactions
    rename_column :jetsteal_seats, :transaction_id, :payment_transaction_id
  end
end
