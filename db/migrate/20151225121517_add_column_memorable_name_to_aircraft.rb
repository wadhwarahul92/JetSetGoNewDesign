class AddColumnMemorableNameToAircraft < ActiveRecord::Migration
  def change
    add_column :aircrafts, :memorable_name, :string
  end
end
