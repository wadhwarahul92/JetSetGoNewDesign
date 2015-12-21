class CreateJetstealSeats < ActiveRecord::Migration
  def change
    create_table :jetsteal_seats do |t|
      t.integer :jetsteal_id
      t.string :ui_seat_id
      t.boolean :disabled, default: false
      t.integer :cost

      t.timestamps null: false
    end
  end
end
