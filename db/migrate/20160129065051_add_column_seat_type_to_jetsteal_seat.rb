class AddColumnSeatTypeToJetstealSeat < ActiveRecord::Migration
  def change
    add_column :jetsteal_seats, :orientation, :integer
    add_column :jetsteal_seats, :seat_type, :string
  end
end
