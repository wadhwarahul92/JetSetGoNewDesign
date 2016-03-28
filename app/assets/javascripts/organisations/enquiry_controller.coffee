organisations_app.controller 'EnquiryController', ['$http', 'enquiry', 'notify', '$timeout', ($http, enquiry, notify, $timeout)->

  @enquiry = enquiry

  @sendQuote = ->
    $http.post("/organisations/trips/#{@enquiry.id}/send_quote.json", {enquiry: @enquiry}).success(
      ->
        notify
          message: 'The quote has been successfully delivered to the client.We shall contact you soon.'
        $timeout(
          ->
            Turbolinks.visit('/organisations')
          ,
          1000
        )
    ).error(
      (data)->
        error = 'Something went wrong.'
        try
          error = data.errors[0]
        notify
          message: error
          classes: ['alert-danger']
    )

  @subTotal = ->
    cost = 0.0
    for activity in @enquiry.activities
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
    s = @subTotal()
    s + ( (@enquiry.tax_value / 100) * s )

  return undefined
]