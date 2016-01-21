class AddColumnsToJetstealSubscription < ActiveRecord::Migration
  def change
    add_column :jetsteal_subscriptions, :date, :string
    add_column :jetsteal_subscriptions, :departure_airport, :string
    add_column :jetsteal_subscriptions, :arrival_airport, :string
    add_column :jetsteal_subscriptions, :pax, :string
  end
end
