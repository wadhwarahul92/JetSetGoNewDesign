class AddColumnSvgToAircraftType < ActiveRecord::Migration
  def change
    add_column :aircraft_types, :svg, :text
  end
end
