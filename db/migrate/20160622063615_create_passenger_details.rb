class CreatePassengerDetails < ActiveRecord::Migration
  def change
    create_table :passenger_details do |t|
      t.string :name
      t.string :gender
      t.string :contact
      t.string :age
      t.string :email
      t.integer :trip_id

      t.timestamps null: false
    end
  end
end
