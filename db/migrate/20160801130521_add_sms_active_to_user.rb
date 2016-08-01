class AddSmsActiveToUser < ActiveRecord::Migration
  def change
    add_column :users, :sms_active, :boolean, default: false
  end
end
