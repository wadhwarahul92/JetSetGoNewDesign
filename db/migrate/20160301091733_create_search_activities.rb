class CreateSearchActivities < ActiveRecord::Migration
  def change
    create_table :search_activities do |t|
      t.integer :search_id
      t.integer :departure_airport_id
      t.integer :arrival_airport_id
      t.datetime :start_at
      t.integer :pax

      t.timestamps null: false
    end
  end
end
