class AddCateringToTrip < ActiveRecord::Migration
  def change
    add_column :trips, :catering, :text
  end
end
