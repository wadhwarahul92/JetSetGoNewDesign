class RecreateColumnToAircrafts < ActiveRecord::Migration
  def change
    remove_column :aircrafts, :operator_id
    add_column :aircrafts, :organisation_id, :integer
  end
end
