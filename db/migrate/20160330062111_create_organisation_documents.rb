class CreateOrganisationDocuments < ActiveRecord::Migration
  def change
    create_table :organisation_documents do |t|
      t.string :name
      t.string :category
      t.string :doc_type
      t.integer :organisation_id
      t.integer :static_file_id

      t.timestamps null: false
    end
  end
end
