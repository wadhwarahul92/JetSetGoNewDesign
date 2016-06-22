class Trip < ActiveRecord::Base

  include VersionTracker

  has_paper_trail

  acts_as_paranoid

  belongs_to :organisation

  belongs_to :user

  has_many :activities

  has_many :passenger_details

  STATUS_QUOTED = 'quoted'

  STATUS_ENQUIRY = 'enquiry'

  STATUS_CONFIRMED = 'confirmed'

  STATUSES = [STATUS_ENQUIRY, STATUS_QUOTED, STATUS_CONFIRMED]

  validates_presence_of :organisation, :status

  validates_inclusion_of :status, in: STATUSES

  def amount_to_pay

    amount = 0.0

    self.activities.each do |activity|
      amount += activity.flight_cost
      amount += activity.handling_cost_at_takeoff
      amount += activity.landing_cost_at_arrival
      if activity.accommodation_plan.present?
        amount += activity.accommodation_plan[:cost]
      end
    end

    amount += ( ( Admin::JSG_COMMISSION_IN_PERCENTAGE / 100 ) * amount )

    amount + ( (Tax.total_tax_value / 100) * amount )

  end

end