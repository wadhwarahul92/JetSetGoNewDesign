class AddColumnLockedAtToJetstealSeat < ActiveRecord::Migration
  def change
    add_column :jetsteal_seats, :locked_at, :datetime
  end
end
