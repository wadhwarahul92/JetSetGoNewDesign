class AddColumnsToUser < ActiveRecord::Migration
  def change
    add_column :users, :enquiry_count, :integer, default: 0
    add_column :users, :last_enquired, :datetime, default: DateTime.now
    add_column :users, :is_allow, :boolean, default: true
  end
end
