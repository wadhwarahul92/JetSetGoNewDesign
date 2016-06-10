organisations_app.controller 'EnquiryController', ['$http', 'enquiry', 'notify', '$timeout', 'CostBreakUpsService', ($http, enquiry, notify, $timeout, CostBreakUpsService)->

  @enquiry = enquiry

  @taxBreakup = CostBreakUpsService.taxBreakUp(@enquiry)

  @grandTotal = CostBreakUpsService.totalTripCost(@enquiry)

  @deleteEnquiry = ->
    bootbox.confirm('Are you sure?', (result)=>
      if result
        $http.delete("/organisations/trips/#{@enquiry.id}/destroy_trip.json").success(
          ->
            Turbolinks.visit('/organisations')
        ).error(
          (data)->
            error = 'Something went wrong.'
            try
              error = data.errors[0]
            notify
              message: error
              classes: ['alert-danger']
        )
    )
    return undefined

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

  return undefined
]