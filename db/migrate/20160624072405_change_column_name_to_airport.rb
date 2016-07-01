class ChangeColumnNameToAirport < ActiveRecord::Migration
  def change
    rename_column :airports, :landing_minimum_amount, :landing_rate_per_tonne
  end
end
