class CreateJsgUpdates < ActiveRecord::Migration
  def change
    create_table :jsg_updates do |t|
      t.text :title
      t.text :description
      t.text :source_url
      t.text :image_url
      t.date :posted_date

      t.timestamps null: false
    end
  end
end
