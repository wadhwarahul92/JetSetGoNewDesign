class AddSellEmptyLegToTrip < ActiveRecord::Migration
  def change
    add_column :trips, :sell_empty_leg, :boolean, default: false
  end
end
