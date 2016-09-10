class ProFormaInvoice < ActiveRecord::Base

  include VersionTracker

  include InvoiceMethods

  has_paper_trail

  acts_as_paranoid

  has_one :invoice

  serialize :itinerary_charges, Array

  serialize :miscellaneous_charges, Array

  serialize :handling_charges, Array

  serialize :accommodation_charges, Array

  validates_presence_of :client_name,
                        :client_address,
                        :invoiced_on,
                        :discount,
                        :discount_unit

  validate def full_validation
    if itinerary_charges and itinerary_charges.length <= 0
      self.errors.add(:itinerary_charges, 'must have at least one entry')
    end
  end

end