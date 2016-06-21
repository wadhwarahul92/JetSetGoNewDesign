class AddGenderNationalityToUser < ActiveRecord::Migration
  def change
    add_column :users, :gender, :string
    add_column :users, :nationality, :string
    add_column :users, :dob, :datetime
  end
end
