class CreateAirportCategories < ActiveRecord::Migration
  def change
    create_table :airport_categories do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
