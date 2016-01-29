class AddColumnSvgToAircraft < ActiveRecord::Migration
  def change
    add_column :aircrafts, :svg, :text, limit: 16.megabytes - 1
  end
end
