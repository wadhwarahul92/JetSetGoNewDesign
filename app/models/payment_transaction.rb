class PaymentTransaction < ActiveRecord::Base

  belongs_to :contact

  #validations
  validates :contact, presence: true
  validates :status, presence: true
  ############

  def success?
    status == 'success'
  end

  def failed?
    status != 'pending' or status != 'success'
  end

  def pending?
    status == 'pending'
  end

end
