class CreateAircraftUnavailabilities < ActiveRecord::Migration
  def change
    create_table :aircraft_unavailabilities do |t|
      t.integer :aircraft_id
      t.datetime :start_at
      t.datetime :end_at
      t.text :reason

      t.timestamps null: false
    end
  end
end
