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
    miscellaneous_expenses = 0.0

    min_mins = 0

    date_list = []
    total_flight_mins = 0
    hours = 0
    minutes = 0

    # self.activities.each do |activity|
    #   amount += activity.flight_cost
    #   amount += activity.handling_cost_at_takeoff
    #   amount += activity.landing_cost_at_arrival
    #   if activity.accommodation_plan.present?
    #     amount += activity.accommodation_plan[:cost]
    #   end
    # end


    self.activities.each do |activity|
      total_handling_cost = 0.0
      amount += (activity.flight_cost + (activity.flight_cost * (activity.aircraft.flight_cost_commission_in_percentage/100.to_f))).round(2)
      total_handling_cost = (activity.handling_cost_at_takeoff + activity.landing_cost_at_arrival)
      amount += (total_handling_cost + (total_handling_cost * (activity.aircraft.handling_cost_commission_in_percentage/100.to_f))).round(2)

      if activity.accommodation_plan.present?
        amount += (activity.accommodation_plan[:cost] + (activity.accommodation_plan[:cost] * (activity.aircraft.accomodation_cost_commission_in_percentage/100.to_f))).round(2)
      end
      date_list << activity.start_at.strftime("%d")
      date_list << activity.end_at.strftime("%d")
      hours = TimeDifference.between(activity.start_at, activity.end_at).in_hours.to_s.split('.')[0].to_i
      minutes = TimeDifference.between(activity.start_at, activity.end_at).in_hours.to_s.split('.')[1].to_i
    end

    min_mins = ((date_list.uniq.count * 2)*60)

    total_flight_mins =  (((hours*60) + minutes))

    if total_flight_mins < min_mins
      miscellaneous_expenses = ((min_mins - total_flight_mins) * (((self.activities.first.aircraft.per_hour_cost)/60) + (self.activities.first.aircraft.per_hour_cost/60 * self.activities.first.aircraft.flight_cost_commission_in_percentage/100.to_f))).round(2)
      amount + miscellaneous_expenses
    end

    # amount += ( ( Admin::JSG_COMMISSION_IN_PERCENTAGE / 100 ) * amount )

    (amount + ( (Tax.total_tax_value / 100) * amount ) + miscellaneous_expenses).to_i
  end

  def payment_transaction
    @payment_transaction = PaymentTransaction.where(id: self.payment_transaction_id)
  end

end