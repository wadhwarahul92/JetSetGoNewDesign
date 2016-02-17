class CreateNotams < ActiveRecord::Migration
  def change
    create_table :notams do |t|
      t.integer :airport_id
      t.datetime :start_at
      t.datetime :end_at

      t.timestamps null: false
    end
  end
end
