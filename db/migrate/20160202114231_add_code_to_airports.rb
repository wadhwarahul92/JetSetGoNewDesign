class AddCodeToAirports < ActiveRecord::Migration
  def change
    add_column :airports, :code, :string
  end
end
