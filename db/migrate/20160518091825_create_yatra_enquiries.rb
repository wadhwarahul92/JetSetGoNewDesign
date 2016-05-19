class CreateYatraEnquiries < ActiveRecord::Migration
  def change
    create_table :yatra_enquiries do |t|
      t.text :name
      t.text :email
      t.text :mobile_number
      t.text :package
      t.datetime :date_of_travel

      t.timestamps null: false
    end
  end
end
