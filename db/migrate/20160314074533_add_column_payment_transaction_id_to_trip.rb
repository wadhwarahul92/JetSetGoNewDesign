class AddColumnPaymentTransactionIdToTrip < ActiveRecord::Migration
  def change
    add_column :trips, :payment_transaction_id, :integer
  end
end
