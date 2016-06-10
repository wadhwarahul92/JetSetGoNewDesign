Services_app.factory 'CostBreakUpsService', ['$http', 'notify', ($http, notify)->

  costBreakUpInstance = {}

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
    cost + costBreakUpInstance.totalTax() / 100 * cost

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