class AddColumnsToAircraft < ActiveRecord::Migration
  def change
    add_column :aircrafts, :one_liner, :text
    add_column :aircrafts, :description, :text
    add_attachment :aircrafts, :specification_image
    add_attachment :aircrafts, :range_map_image
  end
end
