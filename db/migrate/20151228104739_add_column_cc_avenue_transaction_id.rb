class AddColumnCcAvenueTransactionId < ActiveRecord::Migration
  def change
    add_column :jetsteal_seats, :cc_avenue_transaction_id, :integer
  end
end
