class RenameDistanceInDistance < ActiveRecord::Migration
  def change
    rename_column :distances, :distance, :distance_in_nm
  end
end
