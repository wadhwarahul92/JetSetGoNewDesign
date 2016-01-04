class JetstealSeat < ActiveRecord::Base

  #max_lock_time is the time a seat can stay locked for
  MAX_LOCK_TIME = 5.minutes

  class DoubleSaleException < Exception; end

  include VersionTracker

  has_paper_trail

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

  def booked?
    begin
      self.payment_transaction_id.present? and PaymentTransaction.find(self.payment_transaction_id).success?
    rescue
      false
    end
  end

  #locking is different than being booked
  #locking means someone tried to book the seat at that time
  #seat is locked before being booked
  #seat is never sold if its locked
  #lock is time bound, check MAX_LOCK_TIME
  def locked?
    return true if self.locked_at.present? and self.locked_at + MAX_LOCK_TIME > DateTime.now
    false
  end

  #This is highly unlikly and will be raised only if someone buys a seat during the time someone else is in procees of paying for it
  # payment process takes few seconds
  def validate_if_double_sale
    if self.payment_transaction_id && PaymentTransaction.find(self.payment_transaction_id).success?
      raise DoubleSaleException, "Jetsteal seat #{self.id} has been sold twice due to race condition"
    end
  end

end
