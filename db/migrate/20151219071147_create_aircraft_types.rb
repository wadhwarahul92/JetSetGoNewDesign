class CreateAircraftTypes < ActiveRecord::Migration
  def change
    create_table :aircraft_types do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
