class AddColumnPaxToActivity < ActiveRecord::Migration
  def change
    add_column :activities, :pax, :integer
  end
end
