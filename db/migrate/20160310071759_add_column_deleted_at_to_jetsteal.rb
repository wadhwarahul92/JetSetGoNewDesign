class AddColumnDeletedAtToJetsteal < ActiveRecord::Migration
  def change
    add_column :jetsteals, :deleted_at, :datetime
  end
end
