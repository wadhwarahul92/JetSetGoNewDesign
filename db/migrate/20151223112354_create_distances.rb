class CreateDistances < ActiveRecord::Migration
  def change
    create_table :distances do |t|
      t.integer :from_airport_id
      t.integer :to_airport_id
      t.float :distance

      t.timestamps null: false
    end
  end
end
