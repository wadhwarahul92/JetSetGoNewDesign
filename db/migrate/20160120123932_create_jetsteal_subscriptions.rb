class CreateJetstealSubscriptions < ActiveRecord::Migration
  def change
    create_table :jetsteal_subscriptions do |t|
      t.string :email
      t.string :name
      t.string :phone
      t.boolean :send_emails

      t.timestamps null: false
    end
  end
end
