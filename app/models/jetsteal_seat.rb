class JetstealSeat < ActiveRecord::Base

  belongs_to :jetsteal

  #validations
  validates :jetsteal, presence: true
  validates :ui_seat_id, presence: true, uniqueness: { scope: :jetsteal_id }, format: /\Aseat\d+\z/
  validate def cost_presence_if_not_disabled
             unless self.disabled?
               self.errors.add(:cost, 'is required') unless self.cost.present?
             end
  end
  ############

end
