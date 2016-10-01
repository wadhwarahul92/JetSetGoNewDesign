class AddImageToAircraftCategory < ActiveRecord::Migration
  def change
    add_attachment :aircraft_categories, :image
  end
end
