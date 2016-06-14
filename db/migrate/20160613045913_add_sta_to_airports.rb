class AddStaToAirports < ActiveRecord::Migration
  def change
    add_column :airports, :atc, :boolean, default: false
    add_column :airports, :airport_category_id, :integer
  end
end
