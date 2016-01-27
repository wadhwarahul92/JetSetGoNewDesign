class AddNewColumnsToTransaction < ActiveRecord::Migration
  def change
    add_column :payment_transactions, :billing_address, :string
    add_column :payment_transactions, :billing_city, :string
    add_column :payment_transactions, :billing_state, :string
    add_column :payment_transactions, :billing_zip, :string
    add_column :payment_transactions, :billing_country, :string
  end
end
