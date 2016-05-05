organisations_app.controller 'QuoteController', ['quote', '$http', 'notify', (quote, $http, notify)->

  @quote = quote

  @deleteQuote = ->
    $http.delete("/organisations/trips/#{@quote.id}/destroy_trip.json").success(
      ->
        Turbolinks.visit('/organisations')
    )

  @subTotal = ->
    cost = 0.0
    for activity in @quote.activities
      cost += activity.flight_cost
      cost += activity.handling_cost_at_takeoff
      cost += activity.landing_cost_at_arrival
      cost += activity.watch_hour_cost
      if activity.accommodation_plan and activity.accommodation_plan.cost
        cost += activity.accommodation_plan.cost
    cost

  @taxValue = (tax)->
    subTotal = @subTotal()
    ( (tax / 100) * subTotal )

  @grandTotal = ->
    grandTotal = @subTotal()
    grandTotal += @taxValue(@quote.tax_value)
    grandTotal

  return undefined
]