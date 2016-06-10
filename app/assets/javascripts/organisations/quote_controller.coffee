organisations_app.controller 'QuoteController', ['quote', '$http', 'notify', 'CostBreakUpsService', (quote, $http, notify, CostBreakUpsService)->

  @quote = quote

  @taxBreakup = CostBreakUpsService.taxBreakUp(@quote)

  @grandTotal = CostBreakUpsService.totalTripCost(@quote)

  @deleteQuote = ->
    bootbox.confirm 'Are you sure?', (result)=>
      if result
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

#  @grandTotal = ->
#    grandTotal = @subTotal()
#    grandTotal += @taxValue(@quote.tax_value)
#    grandTotal
#
#  @taxValue = (tax)->
#    subTotal = @subTotal()
#    ( (tax / 100) * subTotal )
#
#  @totalTax = (tax)->
#    ( @subTotal() * (tax / 100))

  return undefined
]