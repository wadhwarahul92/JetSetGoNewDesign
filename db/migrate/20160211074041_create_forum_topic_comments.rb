class CreateForumTopicComments < ActiveRecord::Migration
  def change
    create_table :forum_topic_comments do |t|
      t.text :comment
      t.integer :forum_topic_id
      t.integer :operator_id
      t.integer :organisation_id

      t.timestamps null: false
    end
  end
end
