class AddColumnToUser < ActiveRecord::Migration
  def change
    add_column :users, :nsop, :boolean
    add_column :users, :business_detail, :text
  end
end
