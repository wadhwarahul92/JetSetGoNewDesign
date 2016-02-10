class CreateForumTopics < ActiveRecord::Migration
  def change
    create_table :forum_topics do |t|
      t.string :statement
      t.text :description
      t.integer :operator_id
      t.integer :organisation_id

      t.timestamps null: false
    end
  end
end
