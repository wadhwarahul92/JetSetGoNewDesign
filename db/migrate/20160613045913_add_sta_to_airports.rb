class AddStaToAirports < ActiveRecord::Migration
  def change
    add_column :airports, :atc, :boolean
    add_column :airports, :airport_category_id, :integer
  end
end
