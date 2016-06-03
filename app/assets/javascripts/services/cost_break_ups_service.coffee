Services_app.factory 'CostBreakUpsService', ['$http', 'notify', ($http, notify)->

  costBreakUpInstance = {}
  
  tax = 15.0

  serviceTaxCost = 0.0

  costBreakUpInstance.subTotal = (trip)->
    cost = 0.0
    for flight_plan in trip.flight_plan
      cost += flight_plan.flight_cost
      cost += flight_plan.handling_cost_at_takeoff
      cost += flight_plan.landing_cost_at_arrival
      if flight_plan.watch_hour_at_arrival
        cost += flight_plan.watch_hour_cost
      if flight_plan.chosen_intermediate_plan
        chosen_plan = flight_plan[flight_plan.chosen_intermediate_plan]
        if chosen_plan and flight_plan.chosen_intermediate_plan == 'empty_leg_plan'
          for empty_leg in chosen_plan
            cost += empty_leg.flight_cost
            cost += empty_leg.handling_cost_at_takeoff
            cost += empty_leg.landing_cost_at_arrival
            if empty_leg.watch_hour_at_arrival
              cost += empty_leg.watch_hour_cost
        if chosen_plan and flight_plan.chosen_intermediate_plan == 'accommodation_plan'
          cost += chosen_plan.cost
    cost

  costBreakUpInstance.totalTripCost = (trip)->
    cost = costBreakUpInstance.subTotal(trip)
    trip.totalCost = costBreakUpInstance.subTotal(trip)
    cost + (((tax) / 100) * cost)

  costBreakUpInstance.serviceTaxCost = (percentage, trip)->
    costBreakUpInstance.subTotal(trip) * (percentage/100)

  # costBreakUpInstance.checkNotam = (activity)->
  #   for flight_plan in activity.flight_plan
  #     if flight_plan.notam_at_arrival
  #       activity.is_notam = true

  # costBreakUpInstance.checkWatchHour = (trip, activity_)->
  #   for flight_plan in trip.flight_plan
  #     if flight_plan.watch_hour_at_arrival
  #       activity_.is_watch_hour = true

  return costBreakUpInstance
]