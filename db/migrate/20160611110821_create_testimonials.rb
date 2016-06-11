class CreateTestimonials < ActiveRecord::Migration
  def change
    create_table :testimonials do |t|
      t.string :name
      t.text :text
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
