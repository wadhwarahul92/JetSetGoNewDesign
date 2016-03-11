class AddDeletedAtToJsgUpdates < ActiveRecord::Migration
  def change
    add_column :jsg_updates, :deleted_at, :time
  end
end
