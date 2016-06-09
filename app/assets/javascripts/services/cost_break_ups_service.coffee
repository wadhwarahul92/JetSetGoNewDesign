Services_app.factory 'CostBreakUpsService', ['$http', 'notify', ($http, notify)->

  costBreakUpInstance = {}

  taxes = [
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
  
  costBreakUpInstance.taxVal = ()->
    total_tax = 0.0
    for t in taxes
      total_tax += t.value
    total_tax

  costBreakUpInstance.taxCalculate = (cost, tax_percentage)->
    cost * (tax_percentage/100)

  costBreakUpInstance.taxDetails = (cost)->
    taxInfo = []
    for t in taxes
      taxInfo.push({
        name: t.name
        value: t.value 
        tax_in_rupees:  costBreakUpInstance.taxCalculate(cost, t.value)
      })
    taxInfo

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
    trip.totalCost = cost + (((costBreakUpInstance.taxVal()) / 100) * cost)
    trip.totalCost

  costBreakUpInstance.taxBreakUp = (trip)->
    cost = costBreakUpInstance.subTotal(trip)
    costBreakUpInstance.taxDetails(cost)

  return costBreakUpInstance
]