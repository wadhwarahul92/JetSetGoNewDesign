class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.integer :aircraft_id
      t.integer :departure_airport_id
      t.integer :arrival_airport_id
      t.datetime :start_at
      t.datetime :end_at
      t.boolean :empty_leg, default: false

      t.timestamps null: false
    end
  end
end
