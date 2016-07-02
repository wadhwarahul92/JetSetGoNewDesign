class AddImageToAircraft < ActiveRecord::Migration
  def change
    add_attachment :aircrafts, :image
  end
end
