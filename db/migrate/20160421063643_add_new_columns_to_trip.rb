class AddNewColumnsToTrip < ActiveRecord::Migration
  def change
    add_column :trips, :payment_status, :string, default: 'unpaid'
    add_column :trips, :amount_paid, :float, default: 0
  end
end
