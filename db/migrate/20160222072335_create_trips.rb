class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.integer :organisation_id
      t.string :status

      t.timestamps null: false
    end
  end
end
