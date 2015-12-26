class CreateAdminRoleships < ActiveRecord::Migration
  def change
    create_table :admin_roleships do |t|
      t.integer :admin_id
      t.integer :admin_role_id

      t.timestamps null: false
    end
  end
end
