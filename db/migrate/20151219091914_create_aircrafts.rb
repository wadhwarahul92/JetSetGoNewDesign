class CreateAircrafts < ActiveRecord::Migration
  def change
    create_table :aircrafts do |t|
      t.string :tail_number
      t.integer :aircraft_type_id

      t.timestamps null: false
    end
  end
end
