class AddColumnAmountToPaymentTransaction < ActiveRecord::Migration
  def change
    add_column :payment_transactions, :amount, :float
  end
end
