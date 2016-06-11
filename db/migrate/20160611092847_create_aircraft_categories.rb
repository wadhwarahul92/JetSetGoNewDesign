class CreateAircraftCategories < ActiveRecord::Migration
  def change
    create_table :aircraft_categories do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
