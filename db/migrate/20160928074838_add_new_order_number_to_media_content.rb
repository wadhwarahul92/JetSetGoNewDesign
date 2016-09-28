class AddNewOrderNumberToMediaContent < ActiveRecord::Migration
  def change
    add_column :media_contents, :order_number, :integer
  end
end
