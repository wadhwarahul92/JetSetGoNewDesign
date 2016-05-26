class AddColumnDeletedAtToAirport < ActiveRecord::Migration
  def change
    add_column :airports, :deleted_at, :datetime
  end
end
