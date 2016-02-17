class AddColumnIcaoCodeToAirport < ActiveRecord::Migration
  def change
    add_column :airports, :icao_code, :string
  end
end
