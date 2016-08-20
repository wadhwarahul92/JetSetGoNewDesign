Services_app.factory 'CustomerCostBreakUpsService', ['$http', ($http)->

  costBreakUpInstance = {}

  # JSG Commission in percentage

  costBreakUpInstance.commission = 10.0

  #  Tax declarations

  costBreakUpInstance.taxes = [
    {
      name: 'Service Tax'
      value: 14.0
    }
    {
      name: 'Swachh Bharat Cess'
      value: 0.5
    }
    {
      name: 'Krishi Kalyan Cess'
      value: 0.5
    }
  ]

  costBreakUpInstance.totalTax = ->
    _.reduce(
      costBreakUpInstance.taxes
      (m,a)->
        m+a.value
      0
    )

  #  Calculate subTotal of a single search result
  costBreakUpInstance.subTotal = (trip)->
    cost = 0.0

    miscellaneous_expenses = 0.0

    min_mins = 0

    date_list = []
    total_flight_mins = 0
    hours = 0
    minutes = 0


    if trip.flight_plan
      for flight_plan in trip.flight_plan
        cost += flight_plan.flight_cost + (trip.aircraft_flight_cost_commission_in_percentage/100 * flight_plan.flight_cost)
        cost += flight_plan.handling_cost_at_takeoff + (trip.aircraft_handling_cost_commission_in_percentage/100 * flight_plan.handling_cost_at_takeoff)
        # aircraft_handling_cost_commission_in_percentage is same for landing_cost
        cost += flight_plan.landing_cost_at_arrival + (trip.aircraft_handling_cost_commission_in_percentage/100 * flight_plan.landing_cost_at_arrival)
        if flight_plan.watch_hour_at_arrival
          cost += flight_plan.watch_hour_cost + (costBreakUpInstance.commission/100 * flight_plan.watch_hour_cost)
        if flight_plan.accommodation_leg
          cost = cost + (flight_plan.accommodation_leg.cost * flight_plan.accommodation_leg.nights) + (trip.aircraft_accomodation_cost_commission_in_percentage/100 * flight_plan.accommodation_leg.cost)
#        if flight_plan.chosen_intermediate_plan
#          chosen_plan = flight_plan[flight_plan.chosen_intermediate_plan]
#          if chosen_plan and flight_plan.chosen_intermediate_plan == 'empty_leg_plan'
#            for empty_leg in chosen_plan
#              cost += empty_leg.flight_cost + (trip.aircraft_flight_cost_commission_in_percentage/100 * empty_leg.flight_cost)
#              cost += empty_leg.handling_cost_at_takeoff + (trip.aircraft_handling_cost_commission_in_percentage/100 * empty_leg.handling_cost_at_takeoff)
#              cost += empty_leg.landing_cost_at_arrival + (trip.aircraft_handling_cost_commission_in_percentage/100 * empty_leg.landing_cost_at_arrival)
#              if empty_leg.watch_hour_at_arrival
#                cost += empty_leg.watch_hour_cost + (costBreakUpInstance.commission/100 * empty_leg.watch_hour_cost)
#          if chosen_plan and flight_plan.chosen_intermediate_plan == 'accommodation_plan'
#            cost += chosen_plan.cost + (trip.aircraft_accomodation_cost_commission_in_percentage * chosen_plan.cost)

        if flight_plan.flight_type == 'user_search'
          end_at = moment(flight_plan.start_at).add(flight_plan.flight_time.split(':')[0],'hours')
          end_at = moment(end_at).add(flight_plan.flight_time.split(':')[1],'minutes')
          date_list.push(moment(end_at).format('DD'))


          hours += parseInt(flight_plan.flight_time.split(':')[0])
          minutes += parseInt(flight_plan.flight_time.split(':')[1])
    else
      for activity in trip.activities
        cost += activity.flight_cost + (activity.aircraft.aircraft_flight_cost_commission_in_percentage/100 * activity.flight_cost)
        cost += activity.handling_cost_at_takeoff + (activity.aircraft.aircraft_handling_cost_commission_in_percentage/100 * activity.handling_cost_at_takeoff)
        cost += activity.landing_cost_at_arrival + (activity.aircraft.aircraft_handling_cost_commission_in_percentage/100 * activity.landing_cost_at_arrival)
        cost += activity.watch_hour_cost + (costBreakUpInstance.commission/100 * activity.watch_hour_cost)
        if activity.accommodation_plan
          cost = cost + (activity.accommodation_plan.cost * activity.accommodation_plan.nights) + (activity.aircraft.aircraft_accomodation_cost_commission_in_percentage/100 * activity.accommodation_plan.cost)
#        if activity.accommodation_plan and activity.accommodation_plan.cost
#          cost += activity.accommodation_plan.cost + (trip.aircraft_accomodation_cost_commission_in_percentage/100 * activity.accommodation_plan.cost)

    min_mins = ((_.uniq(date_list).length * 2)*60)
    total_flight_mins =  (((hours*60) + minutes))

    if total_flight_mins < min_mins
      debugger

#      miscellaneous_expenses = ((min_mins - total_flight_mins) * (((trip.aircraft.per_hour_cost)/60) + (trip.aircraft.per_hour_cost/60 * trip.aircraft.flight_cost_commission_in_percentage/100.to_f))).round(2)
#      amount + miscellaneous_expenses
#    end
#    (amount + ( (Tax.total_tax_value / 100) * amount ) + miscellaneous_expenses).to_i

    cost

  #  Calculate Grand Total price of a single search result
  costBreakUpInstance.totalTripCost = (trip)->
    cost = costBreakUpInstance.subTotal(trip)
    cost + costBreakUpInstance.totalTax() / 100 * cost

  #  return an array of taxes into Hash form
  costBreakUpInstance.taxBreakUp = (trip)->
    cost = costBreakUpInstance.subTotal(trip)
    array = []
    for tax in costBreakUpInstance.taxes
      array.push(
        {
          name: tax.name
          value: tax.value
          amount: tax.value / 100 * cost
        }
      )
    array

  return costBreakUpInstance
]