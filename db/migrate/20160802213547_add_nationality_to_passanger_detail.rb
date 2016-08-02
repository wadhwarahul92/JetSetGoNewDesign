class AddNationalityToPassangerDetail < ActiveRecord::Migration
  def change
    add_column :passenger_details, :nationality, :string
    add_column :passenger_details, :title, :string
  end
end
