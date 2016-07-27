class AddInteriorImageToAircraft < ActiveRecord::Migration
  def change
    add_attachment :aircrafts, :interior
  end
end
