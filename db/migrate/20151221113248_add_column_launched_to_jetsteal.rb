class AddColumnLaunchedToJetsteal < ActiveRecord::Migration
  def change
    add_column :jetsteals, :launched, :boolean, default: false
  end
end
