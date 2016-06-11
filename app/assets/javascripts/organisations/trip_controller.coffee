organisations_app.controller 'TripController', ['trip', '$http', 'notify', 'activity_id', 'CostBreakUpsService', (trip, $http, notify, activity_id, CostBreakUpsService)->

  @trip = trip

  @activity_id = activity_id

  @taxBreakup = CostBreakUpsService.taxBreakUp(@trip)

  @grandTotal = CostBreakUpsService.totalTripCost(@trip)

  @subTotal = ->
    cost = 0.0
    for activity in @trip.activities
      cost += activity.flight_cost
      cost += activity.handling_cost_at_takeoff
      cost += activity.landing_cost_at_arrival
      cost += activity.watch_hour_cost
      if activity.accommodation_plan and activity.accommodation_plan.cost
        cost += activity.accommodation_plan.cost
    cost

  return undefined
]