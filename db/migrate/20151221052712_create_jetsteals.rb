class CreateJetsteals < ActiveRecord::Migration
  def change
    create_table :jetsteals do |t|
      t.integer :departure_airport_id
      t.integer :arrival_airport_id
      t.integer :aircraft_id
      t.boolean :sell_by_seats, default: true
      t.datetime :start_at
      t.datetime :end_at
      t.integer :cost

      t.timestamps null: false
    end
  end
end
