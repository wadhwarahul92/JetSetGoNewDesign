class CreateStaticFiles < ActiveRecord::Migration
  def change
    create_table :static_files do |t|
      t.timestamps null: false
    end
  end
end
