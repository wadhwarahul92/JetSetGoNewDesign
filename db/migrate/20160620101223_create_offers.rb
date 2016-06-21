class CreateOffers < ActiveRecord::Migration
  def change
    create_table :offers do |t|
      t.datetime :start_at
      t.datetime :end_at
      t.string :category
      t.attachment :image

      t.timestamps null: false
    end
  end
end
