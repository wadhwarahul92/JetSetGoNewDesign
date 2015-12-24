class CreateAircraftImages < ActiveRecord::Migration
  def change
    create_table :aircraft_images do |t|
      t.integer :aircraft_id

      t.timestamps null: false
    end
  end
end
