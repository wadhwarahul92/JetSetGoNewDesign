class AddIsJetstealToPaymentTransaction < ActiveRecord::Migration
  def change
    add_column :payment_transactions, :is_jetsteal, :boolean, default: false
    add_column :payment_transactions, :jetsteal_id, :integer
  end
end
