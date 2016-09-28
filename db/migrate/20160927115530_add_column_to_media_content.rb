class AddColumnToMediaContent < ActiveRecord::Migration
  def change
    add_column :media_contents, :deleted_at, :datetime
  end
end
