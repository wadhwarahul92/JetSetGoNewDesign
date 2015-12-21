class JetstealSeat < ActiveRecord::Base

  belongs_to :jetsteal

  #validations
  validates :jetsteal, presence: true
  validates :ui_seat_id, presence: true, uniqueness: { scope: :jetsteal_id }, format: /\Aseat\d+\z/
  validates :cost, presence: true, numericality: true
  ############

end
