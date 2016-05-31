organisations_app.controller 'TripController', ['trip', '$http', 'notify', (trip, $http, notify)->

  @trip = trip

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

  @grandTotal = ->
    grandTotal = @subTotal()
    grandTotal += @taxValue(@trip.tax_value)
    grandTotal

  @taxValue = (tax)->
    subTotal = @subTotal()
    ( (tax / 100) * subTotal )

  @totalTax = (tax)->
    ( @subTotal() * (tax / 100))

  return undefined
]