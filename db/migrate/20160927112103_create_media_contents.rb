class CreateMediaContents < ActiveRecord::Migration
  def change
    create_table :media_contents do |t|
      t.string :one_liner
      t.text :description
      t.text :image_url
      t.text :redirect_url

      t.timestamps null: false
    end
  end
end
