class ChangeColumnSvgOnArcraftType < ActiveRecord::Migration
  def change
    change_column :aircraft_types, :svg, :text, limit: 16.megabytes - 1
  end
end
