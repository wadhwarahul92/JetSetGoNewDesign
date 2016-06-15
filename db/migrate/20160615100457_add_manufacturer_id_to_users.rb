class AddManufacturerIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :manufacturer_id, :integer
  end
end
