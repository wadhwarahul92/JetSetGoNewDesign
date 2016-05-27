jetsetgo_app.controller 'QuotesController', ['CurrentUserService', '$http', 'notify', (CurentUserService, $http, notify)->

  @quotes = []

  @tax_value = 15

  $http.get('/trips/get_quotes.json').success(
    (data)=>
      @quotes = data
  ).error(
    ->
      notify
        message: 'Error fetching quotes'
        classes: ['alert-danger']
  )

#  @subTotal = (quote)->
#    cost = 0.0
#    for activity in quote.activities
#      cost += activity.flight_cost
#      cost += activity.handling_cost_at_takeoff
#      cost += activity.landing_cost_at_arrival
#      if activity.accommodation_plan and activity.accommodation_plan.cost
#        cost += activity.accommodation_plan.cost
#    cost
#    cost + ( ( quote.jsg_commission/100 ) * cost )
#
#  @taxValue = (tax, quote)->
#    subTotal = @subTotal(quote)
#    ( (tax / 100) * subTotal )
#
#  @grandTotal = (quote)->
#    grandTotal = @subTotal(quote)
#    for tax, value in quote.tax
#      grandTotal += @taxValue(value, quote)
#    grandTotal

  ######
  @subTotal = (quote)->
    cost = 0.0
    for activity in quote.activities
      cost += activity.flight_cost
      cost += activity.handling_cost_at_takeoff
      cost += activity.landing_cost_at_arrival
      cost += activity.watch_hour_cost
      if activity.accommodation_plan and activity.accommodation_plan.cost
        cost += activity.accommodation_plan.cost
    cost

  @taxValue = (tax, quote)->
    subTotal = @subTotal(quote)
    ( (tax / 100) * subTotal )

  @grandTotal = (quote)->
    grandTotal = @subTotal(quote)
    grandTotal += @taxValue(@tax_value, quote)
    grandTotal

  return undefined
]