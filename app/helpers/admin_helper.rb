module AdminHelper

  def attributes_for_model(model)
    model.attributes.keys
  end

  def customer_sub_total_amount(aircraft, trip)
    amount = 0.00
    aircraft
    for activity in trip.activities
      amount += activity.flight_cost + (activity.flight_cost * (aircraft.flight_cost_commission_in_percentage/100.to_f))
      amount += activity.handling_cost_at_takeoff + (activity.handling_cost_at_takeoff * (aircraft.handling_cost_commission_in_percentage/100.to_f))
      amount += activity.landing_cost_at_arrival + (activity.landing_cost_at_arrival * (aircraft.handling_cost_commission_in_percentage/100.to_f))
      if activity.accommodation_plan.present?
        amount += activity.accommodation_plan[:cost] + (activity.accommodation_plan[:cost] * (aircraft.accomodation_cost_commission_in_percentage/100.to_f))
      end
    end

    amount += trip.miscellaneous_expenses if trip.miscellaneous_expenses.present?

    amount.round(2)
  end

  def customer_total_amount(aircraft, trip)
    amount = 0.00
    amount = customer_sub_total_amount(aircraft, trip)
    amount += amount * (15/100.to_f)
    amount.round(2)
  end

  def customer_total_tax(amount)
    tmp_amout = 0.00
    tmp_amout += amount * (15/100.to_f)
    tmp_amout.round(2)
  end

  def amount_with_commission(amount, percentage)
    cost = 0.00
    cost += amount + (amount * (percentage/100.to_f))
    cost
  end
end